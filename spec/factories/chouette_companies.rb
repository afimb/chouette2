Factory.define :company, :class => "Chouette::Company" do |company|
  company.sequence(:name) { |n| "Company #{n}" }
  company.sequence(:objectid) { |n| "test:Company:#{n}" }
  company.sequence(:registration_number) { |n| "test-#{n}" }

end
