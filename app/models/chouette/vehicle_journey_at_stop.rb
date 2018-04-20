module Chouette
  class VehicleJourneyAtStop < TridentActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :stop_point
    belongs_to :vehicle_journey
    has_and_belongs_to_many :footnotes, :class_name => 'Chouette::Footnote', :foreign_key => "vehicle_journey_at_stop_id", :association_foreign_key => "footnote_id"

    attr_accessor :_destroy, :footnote_tokens

    validate :arrival_must_be_before_departure
    def arrival_must_be_before_departure
      # security against nil values
      return unless arrival_time && departure_time
      if exceeds_gap?(arrival_time + arrival_day_offset.day, departure_time + departure_day_offset.day)
        errors.add(:arrival_time, I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure"))
      end
    end

    def self.object_id_key
      "TimetabledPassingTime"
    end


    def footnote_tokens=(ids)
      self.footnote_ids = ids.split(",")
    end

    after_initialize :set_virtual_attributes
    def set_virtual_attributes
      @_destroy = false
    end

    def increasing_times_validate(previous)
      result = true
      return result unless previous

      if exceeds_gap?(previous.departure_time + previous.departure_day_offset.day, departure_time + departure_day_offset.day)
        result = false
        errors.add(:departure_time, I18n.t("activerecord.errors.models.vehicle_journey_at_stop.departure_must_be_before_arrival"))
      end
      if exceeds_gap?(previous.arrival_time + previous.arrival_day_offset.day, arrival_time + arrival_day_offset.day)
        result = false
        errors.add(:arrival_time, I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure"))
      end
      result
    end

    def exceeds_gap?(first, second)
      second < first
    end
  end
end
