FactoryGirl.define do

  factory :stop_point, :class => Chouette::StopPoint do
    sequence(:objectid) { |n| "test:StopPoint:#{n}" }
    association :stop_area, :factory => :stop_area
  end

end
