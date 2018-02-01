FactoryGirl.define do
  factory :route_section, :class => Chouette::RouteSection do
    association :from_scheduled_stop_point, :factory => :scheduled_stop_point
    association :to_scheduled_stop_point, :factory => :scheduled_stop_point
  end
end