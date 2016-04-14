FactoryGirl.define do

  factory :connection_link, :class => Chouette::ConnectionLink do
    sequence(:name) { |n| "Connection link #{n}" }
    sequence(:link_type) { |n| "Mixed" }
    sequence(:objectid) { |n| "test:ConnectionLink:#{n}" }

    association :departure, :factory => :stop_area
    association :arrival, :factory => :stop_area
  end
  
end

