require 'spec_helper'

describe GtfsImport do

  describe "#objectid_prefix" do

    it "should be included in options" do
      subject.objectid_prefix = "dummy"
      subject.options.should include "objectid_prefix" => "dummy"
    end

    it "should be included in import_options" do
      subject.objectid_prefix = "dummy"
      subject.import_options.should include :objectid_prefix => "dummy"
    end
    
  end

  describe "#max_distance_for_commercial" do

    it "should be included in options" do
      subject.max_distance_for_commercial = 300
      subject.options.should include "max_distance_for_commercial" => 300
    end

    it "should be included in import_options" do
      subject.max_distance_for_commercial = 300
      subject.import_options.should include :max_distance_for_commercial => 300
    end
    
  end
  
  describe "#max_distance_for_connection_link" do

    it "should be included in options" do
      subject.max_distance_for_connection_link = 300
      subject.options.should include "max_distance_for_connection_link" => 300
    end

    it "should be included in import_options" do
      subject.max_distance_for_connection_link = 300
      subject.import_options.should include :max_distance_for_connection_link => 300
    end
    
  end

  describe "#ignore_last_word" do

    it "should be included in options" do
      subject.ignore_last_word = true
      subject.options.should include "ignore_last_word" => true
    end

    it "should be included in import_options" do
      subject.ignore_last_word = true
      subject.import_options.should include :ignore_last_word => true
    end
    
  end
  
  describe "#ignore_end_chars" do

    it "should be included in options" do
      subject.ignore_end_chars = 2
      subject.options.should include "ignore_end_chars" => 2
    end

    it "should be included in import_options" do
      subject.ignore_end_chars = 2
      subject.import_options.should include :ignore_end_chars => 2
    end
    
  end

end
