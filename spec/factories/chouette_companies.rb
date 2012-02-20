Factory.define :company, :class => "Chouette::Company" do |company|
  company.sequence(:name) { |n| "Company #{n}" }
  company.sequence(:objectid) { |n| "Company:#{n}" }
end
