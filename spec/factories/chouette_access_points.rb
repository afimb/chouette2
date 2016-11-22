FactoryGirl.define do

  factory :access_point, :class => Chouette::AccessPoint do
    latitude {10.0 * rand}
    longitude {10.0 * rand}
    sequence(:name) { |n| "AccessPoint #{n}" }
    access_type "InOut"
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
  end

end
