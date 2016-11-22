FactoryGirl.define do

  factory :stop_point, :class => Chouette::StopPoint do
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
    association :stop_area, :factory => :stop_area
  end

end
