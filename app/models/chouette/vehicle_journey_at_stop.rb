module Chouette
  class VehicleJourneyAtStop < ActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :stop_point
    belongs_to :vehicle_journey

    attr_accessor :_destroy

    validate :arrival_must_be_before_departure
    def arrival_must_be_before_departure
      # security against nil values
      return unless arrival_time && departure_time
      if exceeds_gap?(arrival_time + arrival_day_offset.day, departure_time + departure_day_offset.day)
        errors.add(:arrival_time,I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure"))
      end
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
        errors.add(:departure_time, 'departure time gap overflow')
      end
      if exceeds_gap?(previous.arrival_time + previous.departure_day_offset.day, arrival_time + arrival_day_offset.day)
        result = false
        errors.add(:arrival_time, 'arrival time gap overflow')
      end
      result
    end

    def exceeds_gap?(first, second)
      (4 * 3600) < ((second - first) % (3600 * 24))
    end
  end
end
