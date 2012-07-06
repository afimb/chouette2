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
      pending
      Export.types.should =~ %w{NeptuneExport}
    end

  end

  describe ".new" do
    
    it "should use type attribute to create a subclass" do
      Export.new(:type => "NeptuneExport").should be_an_instance_of(NeptuneExport)
    end

  end

  describe "#references" do

    it "should be empty if references_type is nil" do
      subject.references_type = nil
      subject.references.should be_empty
    end

    it "should be empty if reference_ids is blank" do
      subject.reference_ids = ""
      subject.references.should be_empty
    end

  end

  describe "#references=" do

    context "with Lines" do

      let(:lines) { create_list :line, 3 }

      before(:each) do
        subject.references = lines
      end

      it "should use 'Chouette::Line' as references_type" do
        subject.references_type.should == 'Chouette::Line'
      end

      it "should use line identifiers as raw reference_ids" do
        subject.raw_reference_ids.should == lines.map(&:id).join(',')
      end
                        
    end

  end

  describe "#references_relation" do
    
    it "should be 'lines' when relation_type is 'Chouette::Line'" do
      subject.references_type = "Chouette::Line"
      subject.references_relation.should == "lines"
    end

    it "should be 'networks' when relation_type is 'Chouette::Network'" do
      subject.references_type = "Chouette::Network"
      subject.references_relation.should == "networks"
    end

    it "should be nil when relation_type is blank" do
      subject.references_type = ""
      subject.references_relation.should be_nil
    end

    it "should be nil when relation_type is 'dummy'" do
      subject.references_type = "dummy"
      subject.references_relation.should be_nil
    end

  end

  describe "#reference_ids" do
    
    it "should parse raw_reference_ids and returns ids" do
      subject.stub :raw_reference_ids => "1,2,3"
      subject.reference_ids.should == [1,2,3]
    end

    it "should be empty if raw_reference_ids is blank" do
      subject.stub :raw_reference_ids => ""
      subject.reference_ids.should be_empty
    end

  end

  describe "#reference_ids=" do
    
    it "should join ids with comma" do
      subject.reference_ids = [1,2,3]
      subject.raw_reference_ids.should == "1,2,3"
    end

    it "should be nil if records is blank" do
      subject.reference_ids = []
      subject.raw_reference_ids.should be_nil
    end

  end

end
