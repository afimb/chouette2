# require 'spec_helper'
#
# RSpec.describe Chouette::RouteSection, :type => :model do
#
#   subject { create :route_section }
#
#   it { should validate_presence_of(:departure) }
#   it { should validate_presence_of(:arrival) }
#
#   describe "#default_geometry" do
#
#     it "should return nil when departure isn't defined" do
#       subject.departure  = nil
#       expect(subject.default_geometry).to be_nil
#     end
#
#     it "should return nil when arrival isn't defined" do
#       subject.arrival  = nil
#       expect(subject.default_geometry).to be_nil
#     end
# 
#     it "should return nil when departure has no geometry" do
#       subject.departure.stub :geometry
#       expect(subject.default_geometry).to be_nil
#     end
#
#     it "should return nil when arrival has no geometry" do
#       subject.arrival.stub :geometry
#       expect(subject.default_geometry).to be_nil
#     end
#
#     it "should use departure geometry as first point" do
#       expect(subject.default_geometry.first).to eq(subject.departure.geometry)
#     end
#
#   end
#
#   describe "#process_geometry" do
#
#     let(:sample_geometry) { line_string("0 0,1 1").to_rgeo }
#
#     context "without processor" do
#
#       it "should use the input geometry" do
#         subject.input_geometry = sample_geometry
#         subject.process_geometry
#         expect(subject.processed_geometry).to eq(subject.input_geometry)
#       end
#
#       it "should use the default geometry when no input is defined" do
#         subject.input_geometry = nil
#         subject.process_geometry
#         expect(subject.processed_geometry).to eq(subject.default_geometry.to_rgeo)
#       end
#
#     end
#
#     # context "with a processor" do
#     #
#     #   it "should use the processor result" do
#     #     subject.processor = Proc.new { |s| sample_geometry }
#     #     subject.process_geometry
#     #     subject.processor = nil
#     #     expect(subject.processed_geometry).to eq(sample_geometry)
#     #   end
#     # end
#   end
#
#   describe "#distance" do
#
#     context "with simple line" do
#       let(:sample_geometry) { line_string("2.329534 48.842397,2.325725 48.855839").to_rgeo }
#       it "should return the right distance" do
#         subject.input_geometry = sample_geometry
#         subject.process_geometry
#         expect(subject.distance).to eq(sample_geometry.to_georuby.spherical_distance)
#       end
#     end
#
#     context "with complex line" do
#       let(:sample_geometry) { line_string("2.329561 48.842397, 2.329351 48.843119, 2.329152 48.843801, 2.3289820000000003 48.844426,2.3287960000000005 48.845059,2.3286540000000007 48.845575,2.3283130000000005 48.846748,2.3281220000000005 48.847404999999995,2.3279330000000003 48.848088,2.3278860000000003 48.848245999999996,2.3273240000000004 48.850142999999996,2.3273030000000006 48.850218999999996,2.3271630000000005 48.850745999999994,2.3270140000000006 48.85130999999999,2.3269350000000006 48.85142799999999,2.3268640000000005 48.85153599999999,2.3268290000000005 48.85161099999999,2.3267490000000004 48.85180999999999,2.3267700000000002 48.852053999999995,2.326759 48.852216999999996,2.326687 48.852427999999996,2.3266620000000002 48.852512,2.3264280000000004 48.853286,2.3264050000000003 48.853362,2.3263710000000004 48.853483,2.326125 48.854343,2.3259980000000002 48.854727,2.325737 48.855833999999994").to_rgeo }
#       it "should return the right distance" do
#         subject.input_geometry = sample_geometry
#         subject.process_geometry
#         expect(subject.distance).to eq(sample_geometry.to_georuby.spherical_distance)
#       end
#     end
#
#   end
#
#
#
# end
