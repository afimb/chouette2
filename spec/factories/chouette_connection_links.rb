FactoryGirl.define do

  factory :connection_link, :class => Chouette::ConnectionLink do
    sequence(:name) { |n| "Connection link #{n}" }
    sequence(:link_type) { |n| "Mixed" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }

    association :departure, :factory => :stop_area
    association :arrival, :factory => :stop_area
  end

end

