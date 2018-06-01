module Chouette
  class VehicleJourney < TridentActiveRecord
    include VehicleJourneyRestrictions
    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    enum journey_category: { timed: 0, frequency: 1 }

    default_scope { where(journey_category: journey_categories[:timed]) }

    attr_accessor :transport_mode_name, :transport_submode, :recalculate_offset, :service_alteration_name
    attr_reader :time_table_tokens, :footnote_tokens

    def self.nullable_attributes
      [:transport_mode, :transport_submode_name, :published_journey_name, :vehicle_type_identifier, :published_journey_identifier, :comment, :status_value, :service_alteration]
    end

    belongs_to :company
    belongs_to :route
    belongs_to :journey_pattern

    has_many :vehicle_journeys_key_values
    has_and_belongs_to_many :footnotes, :class_name => 'Chouette::Footnote', :foreign_key => "vehicle_journey_id", :association_foreign_key => "footnote_id"

    validates_presence_of :route
    validates_presence_of :journey_pattern

    has_many :vehicle_journey_at_stops, -> { includes(:stop_point).order("stop_points.position") }, :dependent => :destroy
    has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehicle_journey_id", :association_foreign_key => "time_table_id"
    has_many :stop_points, -> { order("stop_points.position") }, :through => :vehicle_journey_at_stops

    validate :increasing_times
    validates_presence_of :number

    belongs_to :flexible_service_properties, :class_name => 'Chouette::FlexibleServiceProperties', :dependent => :destroy
    accepts_nested_attributes_for :flexible_service_properties, :allow_destroy => :true

    before_validation :set_default_values
    def set_default_values
      if number.nil?
        self.number = 0
      end
    end

    after_save :recalculate_day_offset

    scope :without_any_time_table, -> { joins('LEFT JOIN "time_tables_vehicle_journeys" ON "time_tables_vehicle_journeys"."vehicle_journey_id" = "vehicle_journeys"."id" LEFT JOIN "time_tables" ON "time_tables"."id" = "time_tables_vehicle_journeys"."time_table_id"').where(:time_tables => { :id => nil}) }
    scope :without_any_passing_time, -> { joins('LEFT JOIN "vehicle_journey_at_stops" ON "vehicle_journey_at_stops"."vehicle_journey_id" = "vehicle_journeys"."id"').where(vehicle_journey_at_stops: { id: nil }) }

    accepts_nested_attributes_for :vehicle_journey_at_stops, :allow_destroy => true


    def presenter
      @presenter ||= ::VehicleJourneyPresenter.new( self)
    end

    def transport_mode_name
      # return nil if transport_mode is nil
      transport_mode && Chouette::TransportMode.new( transport_mode.underscore)
    end

    def transport_mode_name=(transport_mode_name)
      self.transport_mode = (transport_mode_name ? transport_mode_name.camelcase : nil)
    end

    @@transport_mode_names = nil
    def self.transport_mode_names
      @@transport_mode_names ||= Chouette::TransportMode.all.select do |transport_mode_name|
        transport_mode_name.to_i > 0
      end
    end

    def transport_submode
      # return nil if transport_submode_name is nil
      transport_submode_name && Chouette::TransportSubMode.new( transport_submode_name.underscore)
    end

    def transport_submode=(transport_submode)
      self.transport_submode_name = (transport_submode ? transport_submode.camelcase : nil)
    end

    @@transport_submodes = nil
    def self.transport_submodes
      @@transport_submodes ||= Chouette::TransportSubMode.all.select do |transport_submode|
        transport_submode.to_i > -1
      end
    end

    def service_alteration_name
      # return nil if service_alteration is nil
      service_alteration && Chouette::ServiceAlteration.new( service_alteration.underscore)
    end

    def service_alteration_name=(service_alteration_name)
      self.service_alteration = (service_alteration_name ? service_alteration_name.camelcase : nil)
    end

    @@service_alterations = nil
    def self.service_alterations
      @@service_alterations ||= Chouette::ServiceAlteration.all.select do |service_alteration|
        service_alteration.to_i > -1
      end
    end

    @flexible_service_types = nil

    def self.flexible_service_types
      @flexible_service_types ||= Chouette::FlexibleServiceType.all.select do |flexible_service_type|
        flexible_service_type.to_i > -1
      end
    end


    def increasing_times
      previous = nil
      vehicle_journey_at_stops.select{|vjas| vjas.departure_time && vjas.arrival_time}.each do |vjas|
        errors.add(:vehicle_journey_at_stops) unless vjas.increasing_times_validate(previous)
        previous = vjas
      end
    end

    def missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      selected_journey_pattern.stop_points - self.stop_points
    end
    def extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      self.stop_points - selected_journey_pattern.stop_points
    end
    def extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern)
      extra_stops = self.extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      self.vehicle_journey_at_stops.select { |vjas| extra_stops.include?( vjas.stop_point)}
    end
    def time_table_tokens=(ids)
      self.time_table_ids = ids.split(",")
    end

    def footnote_tokens=(ids)
      self.footnote_ids = ids.split(",")
    end


    def bounding_dates
      dates = []

      time_tables.each do |tm|
        dates << tm.start_date if tm.start_date
        dates << tm.end_date if tm.end_date
      end

      dates.empty? ? [] : [dates.min, dates.max]
    end

    def update_journey_pattern( selected_journey_pattern)
      return unless selected_journey_pattern.route_id==self.route_id

      missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |sp|
        self.vehicle_journey_at_stops.build( :stop_point => sp)
      end
      extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |vjas|
        vjas._destroy = true
      end
    end

    def self.matrix(vehicle_journeys)
      {}.tap do |hash|
        vehicle_journeys.map{ |vj|
          vj.vehicle_journey_at_stops.map{ |vjas |hash[ "#{vj.id}-#{vjas.stop_point_id}"] = vjas }
        }
      end
    end

    def recalculate_day_offset
      return unless recalculate_offset

      vjass = self.vehicle_journey_at_stops
      return unless vjass.present?

      previous_vjas = arrival_offset = departure_offset = 0
      vjass.each do |vjas|
        if previous_vjas == 0
          departure_offset += 1 if vjas.departure_time < vjas.arrival_time
        else
          arrival_offset += 1 if vjas.arrival_time < previous_vjas.arrival_time
          departure_offset += 1 if vjas.departure_time < previous_vjas.departure_time
        end
        previous_vjas = vjas
        next if arrival_offset == 0 && departure_offset == 0
        vjas.arrival_day_offset = arrival_offset
        vjas.departure_day_offset = departure_offset
        vjas.save
      end
    end
  end
end
