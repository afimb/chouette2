FactoryGirl.define do

  factory :access_point, :class => Chouette::AccessPoint do
    latitude {10.0 * rand}
    longitude {10.0 * rand}
    sequence(:name) { |n| "AccessPoint #{n}" }
    access_type "InOut"
    sequence(:objectid) { |n| "test:AccessPoint:#{n}" }
  end

end
