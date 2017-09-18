module Chouette
  class StopPoint < TridentActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :scheduled_stop_point
    belongs_to :route, inverse_of: :stop_points
    has_one :stop_area, :through => :scheduled_stop_point
    has_many :vehicle_journey_at_stops, :dependent => :destroy
    has_many :vehicle_journeys, -> {uniq}, :through => :vehicle_journey_at_stops
    belongs_to :destination_display

    acts_as_list :scope => :route, top_of_list: 0

    validates_presence_of :scheduled_stop_point
    validate :scheduled_stop_point_id_validation
    has_and_belongs_to_many :footnotes, :class_name => 'Chouette::Footnote', :foreign_key => "stop_point_id", :association_foreign_key => "footnote_id"

    attr_reader :footnote_tokens

    scope :default_order, -> { order("position") }

    accepts_nested_attributes_for :scheduled_stop_point

    before_destroy :remove_dependent_journey_pattern_stop_points
    def remove_dependent_journey_pattern_stop_points
      route.journey_patterns.each do |jp|
        if jp.stop_point_ids.include?( id)
          jp.stop_point_ids = jp.stop_point_ids - [id]
        end
      end
    end

    def name
      stop_area != nil ? stop_area.name : '?'
    end

    def scheduled_stop_point_id_validation
      if scheduled_stop_point.nil?
        errors.add(:scheduled_stop_point, I18n.t("errors.messages.empty"))
      end
    end

    def self.area_candidates
      Chouette::StopArea.where( :area_type => ['Quay', 'BoardingPosition'])
    end

    def destination_display_id=(id)
      self.destination_display = id.nil? ? nil : Chouette::DestinationDisplay.find(id)
      save
    end

    def footnote_tokens=(ids)
      self.footnotes_ids = ids.split(",")
    end

    # For referring to either an existing scheduled stop point or create a new from stop area reference from UI.
    # Probably not the best way to solve this...

    def scheduled_stop_point_id_or_stop_area_objectid_key

      if (scheduled_stop_point_id || stop_area)
        if (stop_area)
          stop_area_objectid=stop_area.object_id
        end
        [scheduled_stop_point_id, stop_area_objectid].join(',')
      end
    end

    def scheduled_stop_point_id_or_stop_area_objectid_key=(data)
      split=data.split(',')
      if (split.first && !split.first.empty?)
        self.scheduled_stop_point=Chouette::ScheduledStopPoint.find(split.first)
      else
        self.scheduled_stop_point= Chouette::ScheduledStopPoint.new(:stop_area_objectid_key => split.last)
      end
    end

    def scheduled_stop_point_name
      if (scheduled_stop_point)
        scheduled_stop_point.name
      end
    end

    def scheduled_stop_point_name=(name)
      if (scheduled_stop_point)
        scheduled_stop_point.name = name
      end
    end

  end

end
