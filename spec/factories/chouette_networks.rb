Factory.define :network, :class => "Chouette::Network" do |network|
  network.sequence(:name) { |n| "Network #{n}" }
  network.sequence(:objectid) { |n| "test:GroupOfLine:#{n}" }
  network.sequence(:registration_number) { |n| "test-#{n}" }

end
