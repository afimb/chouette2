FactoryGirl.define do

  factory :route_common, :class => Chouette::Route do
    sequence(:name) { |n| "Route #{n}" }
    sequence(:published_name) { |n| "Long route #{n}" }
    sequence(:number) { |n| "#{n}" }
    sequence(:wayback_code) { |n| Chouette::Wayback.new( n % 2) }
    sequence(:direction_code) { |n| Chouette::Direction.new( n % 12) }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }

    association :line, :factory => :line

    factory :route do

      transient do
        stop_points_count 5
      end

      after(:create) do |route, evaluator|
        create_list(:stop_point, evaluator.stop_points_count, route: route)
      end

    end
  end

end
