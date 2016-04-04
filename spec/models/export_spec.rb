# require 'spec_helper'

# describe Export, :type => :model do

#   subject { create :export }

#   RSpec::Matchers.define :be_log_message do |expected|
#     match do |actual|
#       actual and expected.all? { |k,v| actual[k.to_s] == v }
#     end
#   end

#   describe "#export" do

#     before(:each) do
#       allow(subject).to receive_messages :exporter => double(:export => true)
#     end

#     it "should create a ExportLogmessage :started when started" do
#       subject.export
#       expect(subject.log_messages.first).to be_log_message(:key => "started")
#     end

#     it "should create a ExportLogmessage :completed when completed" do
#       subject.export
#       expect(subject.log_messages.last).to be_log_message(:key => "completed")
#     end

#     it "should create a ExportLogmessage :failed when failed" do
#       pending
#       # subject.loader.stub(:export).and_raise("export failed")
#       subject.export
#       expect(subject.log_messages.last).to be_log_message(:key => "failed")
#     end

#   end

#   describe "#options" do

#     it "should be empty by default" do
#       expect(subject.options).to be_empty
#     end

#   end

#   describe ".types" do

#     it "should return available Export implementations" do
#       expect(Export.types).to match_array(%w{NeptuneExport CsvExport GtfsExport NetexExport SigExport HubExport})
#     end

#   end

#   describe ".new" do

#     it "should use type attribute to create a subclass" do
#       expect(Export.new(:type => "NeptuneExport")).to be_an_instance_of(NeptuneExport)
#     end

#   end

#   it_behaves_like TypeIdsModelable do
#     let(:type_ids_model) { subject}
#   end

# end
