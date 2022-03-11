FactoryBot.define do

  factory :journey_frequency, class: Chouette::JourneyFrequency do
    timeband
    scheduled_headway_interval { Time.current }
    first_departure_time { timeband.start_time }
    last_departure_time { timeband.end_time }
  end

  factory :journey_frequency_first_departure_time_invalid, class: Chouette::JourneyFrequency do
    timeband
    scheduled_headway_interval { Time.current }
    first_departure_time { timeband.start_time - 1.minute }
    last_departure_time { timeband.end_time }
  end

  factory :journey_frequency_last_departure_time_invalid, class: Chouette::JourneyFrequency do
    timeband
    scheduled_headway_interval { Time.current }
    first_departure_time { timeband.start_time }
    last_departure_time { timeband.end_time + 1.minute }
  end

  factory :journey_frequency_departure_time_invalid, class: Chouette::JourneyFrequency do
    timeband
    scheduled_headway_interval { Time.current }
    first_departure_time { '00:00' }
    last_departure_time { '00:00' }
  end

  factory :journey_frequency_scheduled_headway_interval_invalid, class: Chouette::JourneyFrequency do
    timeband
    scheduled_headway_interval { '00:00' }
    first_departure_time { timeband.start_time }
    last_departure_time { timeband.end_time }
  end

end
