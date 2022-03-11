FactoryBot.define do

  factory :company, :class => Chouette::Company do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:objectid) { |n| "test:Company:#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
    sequence(:organisation_type) { |n| "Operator" }
  end

end
