FactoryGirl.define do
  factory :route_section, :class => Chouette::RouteSection do
    association :departure, :factory => :stop_area
    association :arrival, :factory => :stop_area
  end
end
