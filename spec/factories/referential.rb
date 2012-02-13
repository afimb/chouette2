Factory.define :referential, :class => "Referential" do |f|
  f.sequence(:name) { |n| "Referential #{n}" }
  f.sequence(:slug) { |n| "referential_#{n}" }
end