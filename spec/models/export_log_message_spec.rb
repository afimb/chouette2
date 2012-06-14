require 'spec_helper'

describe ExportLogMessage do

  describe "#attributes" do

    subject { create :export_log_message }

    it "should read json stored in database" do
      subject.update_attribute :arguments, { "key" => "value"}
      subject.raw_attributes.should == { "key" => "value"}.to_json
    end

  end

end
