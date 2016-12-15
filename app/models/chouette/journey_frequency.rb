module Chouette

  class JourneyFrequencyValidator < ActiveModel::Validator
    def validate(record)
      timeband = record.timeband
      if timeband
        first_departure_time = record.first_departure_time.utc.strftime( "%H%M%S%N" )
        last_departure_time  = record.last_departure_time.utc.strftime( "%H%M%S%N" )
        timeband_start_time  = timeband.start_time.utc.strftime( "%H%M%S%N" )
        timeband_end_time    = timeband.end_time.utc.strftime( "%H%M%S%N" )

        unless first_departure_time.between? timeband_start_time, timeband_end_time
          record.errors[:first_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.start_must_be_after_timeband')
        end
        unless last_departure_time.between? timeband_start_time, timeband_end_time
          record.errors[:last_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.end_must_be_before_timeband')
        end
      end
      if record.first_departure_time == record.last_departure_time
        record.errors[:last_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.end_must_be_different_from_first')
      end
      if record.scheduled_headway_interval.blank? || (record.scheduled_headway_interval.strftime( "%H%M%S%N" ) == Time.current.midnight.strftime( "%H%M%S%N" ))
        record.errors[:scheduled_headway_interval] << I18n.t('activerecord.errors.models.journey_frequency.scheduled_headway_interval_greater_than_zero')
      end
    end
  end

  class JourneyFrequency < ActiveRecord
    belongs_to :vehicle_journey_frequency, foreign_key: 'vehicle_journey_id'
    belongs_to :timeband
    validates :first_departure_time, presence: true
    validates :last_departure_time,  presence: true
    validates :scheduled_headway_interval, presence: true
    validates_with JourneyFrequencyValidator
  end
end
