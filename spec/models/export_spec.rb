require 'spec_helper'

describe Export do

  subject { create :export }

  RSpec::Matchers.define :be_log_message do |expected|
    match do |actual|
      actual and expected.all? { |k,v| actual[k.to_s] == v }
    end
  end

  describe "#export" do

    before(:each) do
      subject.stub :exporter => mock(:export => true)
    end

    it "should create a ExportLogmessage :started when started" do
      subject.export
      subject.log_messages.first.should be_log_message(:key => "started")
    end

    it "should create a ExportLogmessage :completed when completed" do
      subject.export
      subject.log_messages.last.should be_log_message(:key => "completed")
    end

    it "should create a ExportLogmessage :failed when failed" do
      pending
      # subject.loader.stub(:export).and_raise("export failed")
      subject.export
      subject.log_messages.last.should be_log_message(:key => "failed")
    end

  end

  describe "#options" do

    it "should be empty by default" do
      subject.options.should be_empty
    end

  end

  describe ".types" do

    it "should return available Export implementations" do
      Export.types.should =~ %w{NeptuneExport CsvExport GtfsExport NetexExport KmlExport}
    end

  end

  describe ".new" do

    it "should use type attribute to create a subclass" do
      Export.new(:type => "NeptuneExport").should be_an_instance_of(NeptuneExport)
    end

  end

  it_behaves_like TypeIdsModelable do
    let(:type_ids_model) { subject}
  end

end
