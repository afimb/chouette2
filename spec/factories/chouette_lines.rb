FactoryGirl.define do

  factory :line, :class => Chouette::Line do
    sequence(:name) { |n| "Line #{n}" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
    sequence(:transport_mode_name) { |n| "Bus" }

    association :network, :factory => :network
    association :company, :factory => :company

    sequence(:registration_number) { |n| "test-#{n}" }

    factory :line_with_stop_areas do

      transient do
        routes_count 2
        stop_areas_count 5
      end

      after(:create) do |line, evaluator|
        create_list(:route, evaluator.routes_count, :line => line) do |route|
          create_list(:stop_area, evaluator.stop_areas_count, area_type: "Quay") do |stop_area|
            create(:stop_point, :stop_area => stop_area, :route => route)
          end
        end
      end

      factory :line_with_stop_areas_having_parent do

        after(:create) do |line|
          line.routes.each do |route|
            route.stop_points.each do |stop_point|
              comm = create(:stop_area, :area_type => "CommercialStopPoint")
              stop_point.stop_area.update_attributes(:parent_id => comm.id)
            end
          end
        end
      end

    end

  end

end
