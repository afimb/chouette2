Factory.define :line, :class => "Chouette::Line" do |line|
  line.sequence(:name) { |n| "Line #{n}" }
  line.sequence(:objectid) { |n| "Line:#{n}" }
  line.association :network, :factory => :network
  line.association :company, :factory => :company
end
