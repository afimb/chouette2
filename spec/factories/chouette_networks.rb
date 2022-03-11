FactoryBot.define do

  factory :network, :class => Chouette::Network do
    sequence(:name) { |n| "Network #{n}" }
    sequence(:objectid) { |n| "test:GroupOfLine:#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
  end

end
