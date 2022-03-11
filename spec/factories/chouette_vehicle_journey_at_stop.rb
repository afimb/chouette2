FactoryBot.define do
  
  factory :vehicle_journey_at_stop, :class => Chouette::VehicleJourneyAtStop do
    association :vehicle_journey, :factory => :vehicle_journey
  end

end

