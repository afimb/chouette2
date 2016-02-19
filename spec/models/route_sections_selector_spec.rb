# require 'spec_helper'
#
# describe RouteSectionsSelector, :type => :model do
#
#   let(:stop_points) { create_list :stop_point, 5 }
#   let(:itinerary) { double stop_points: stop_points, route_sections: [] }
#
#   subject { RouteSectionsSelector.new itinerary }
#
#   describe "#sections" do
#
#     it "should create a Section between each StopPoint" do
#       expect(subject.sections.size).to eq(stop_points.size - 1)
#     end
#
#   end
#
# end
#
# describe RouteSectionsSelector::Section, :type => :model do
#
#   let(:departure) { create :stop_point }
#   let(:arrival) { create :stop_point }
#
#   subject { RouteSectionsSelector::Section.new departure, arrival }
#
#   let(:route_sections) do
#     create_list :route_section, 5,
#                 departure: departure.stop_area,
#                 arrival: arrival.stop_area
#   end
#
#   describe "#candidates" do
#     it "should return an empty array when no RouteSection exists" do
#       expect(subject.candidates).to be_empty
#     end
#
#     it "should return the RouteSections with the same departure/arrival StopAreas" do
#       expect(subject.candidates).to match_array(route_sections)
#     end
#   end
#
# end
