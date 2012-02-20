# Factory.define :chouette_stop_area, :class => "Chouette::StopArea" do |f|
#   f.latitude 10 * rand
#   f.longitude 10 * rand
#   f.sequence(:name) { |n| "StopArea #{n}" }
#   f.areatype "CommercialStopPoint"
#   f.objectid
# end