FactoryGirl.define do

  factory :company, :class => Chouette::Company do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:objectid) { |n| "test:Company:#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
  end

end
