require 'spec_helper'

describe CsvImport do

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

end
