Factory.define :company, :class => "Chouette::Company" do |f|
  f.sequence(:name) { |n| "Company #{n}" }
end
