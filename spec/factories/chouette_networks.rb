Factory.define :network, :class => "Chouette::Network" do |f|
  f.sequence(:name) { |n| "Network #{n}" }
end
