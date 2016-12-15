FactoryGirl.define do

  factory :stop_area, :class => Chouette::StopArea do
    sequence(:objectid) { |n| "test:StopArea:#{n}" }
    sequence(:name) { |n| "stop_area_#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
    area_type "CommercialStopPoint"
    latitude {10.0 * rand}
    longitude {10.0 * rand}
  end

end
