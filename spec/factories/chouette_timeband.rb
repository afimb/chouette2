FactoryGirl.define do

  factory :timeband, class: Chouette::Timeband do
    sequence(:name) { |n| "Name: #{n}" }
    start_time { Time.now }
    end_time { Time.now + 1.hour }
    sequence(:objectid) { |n| "test:Timeband:#{n}" }
  end

  factory :timeband_invalid, class: Chouette::Timeband do
    sequence(:name) { |n| "Name: #{n}" }
    start_time { Time.now + 1.hour }
    end_time { Time.now }
    sequence(:objectid) { |n| "test:Timeband:#{n}" }
  end

end
