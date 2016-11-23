FactoryGirl.define do

  factory :journey_pattern_common, :class => Chouette::JourneyPattern do
    sequence(:name) { |n| "jp name #{n}" }
    sequence(:published_name) { |n| "jp publishedname #{n}" }
    sequence(:comment) { |n| "jp comment #{n}" }
    sequence(:registration_number) { |n| "jp registration_number #{n}" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }

    association :route, :factory => :route

    factory :journey_pattern do
      after(:create) do |j|
        j.stop_point_ids = j.route.stop_points.map(&:id)
        j.departure_stop_point_id = j.route.stop_points.first.id
        j.arrival_stop_point_id = j.route.stop_points.last.id
      end
    end

    factory :journey_pattern_odd do
      after(:create) do |j|
        j.stop_point_ids = j.route.stop_points.select { |sp| sp.position%2==0}.map(&:id)
        j.departure_stop_point_id = j.stop_point_ids.first
        j.arrival_stop_point_id = j.stop_point_ids.last
      end
    end

    factory :journey_pattern_even do
      after(:create) do |j|
        j.stop_point_ids = j.route.stop_points.select { |sp| sp.position%2==1}.map(&:id)
        j.departure_stop_point_id = j.stop_point_ids.first
        j.arrival_stop_point_id = j.stop_point_ids.last
      end
    end

  end

end


