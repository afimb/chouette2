require 'spec_helper'

describe Import do

  subject { create :import }

  RSpec::Matchers.define :be_log_message do |expected|
    match do |actual|
      actual and expected.all? { |k,v| actual[k.to_s] == v }
    end
  end
  
  describe "#import" do

    before(:each) do
      subject.stub :loader => mock(:import => true)
    end

    it "should create a ImportLogmessage :started when started" do
      subject.import
      subject.log_messages.first.should be_log_message(:key => "started")
    end

    it "should create a ImportLogmessage :completed when completed" do
      subject.import
      subject.log_messages.last.should be_log_message(:key => "completed")
    end

    it "should create a ImportLogmessage :failed when failed" do
      subject.loader.stub(:import).and_raise("import failed")
      subject.import
      subject.log_messages.last.should be_log_message(:key => "failed")
    end

  end

  describe "#options" do
    
    it "should be empty by default" do
      subject.options.should be_empty
    end

  end

  describe ".types" do
    
    it "should return available Import implementations" do
      Import.types.should =~ %w{NeptuneImport CsvImport}
    end

  end

  describe ".new" do
    
    it "should use type attribute to create a subclass" do
      Import.new(:type => "NeptuneImport").should be_an_instance_of(NeptuneImport)
    end

  end

end
