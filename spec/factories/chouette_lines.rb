Factory.define :chouette_line, :class => "Chouette::Line" do |f|
  f.sequence(:name) { |n| "Line #{n}" }
  f.objectid
end