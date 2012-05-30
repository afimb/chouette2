require 'spec_helper'

describe ImportLogMessage do

  describe "#attributes" do

    subject { create :import_log_message }

    it "should read json stored in database" do
      subject.update_attribute :arguments, { "key" => "value"}
      subject.raw_attributes.should == { "key" => "value"}.to_json
    end

  end

end
