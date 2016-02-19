require 'spec_helper'

describe GtfsExport, :type => :model do

  describe "#time_zone" do

    context "when exported data are not StopAreas" do

      before do
        subject.references_type = "network"
      end

      it "should be mandatory" do
        should validate_presence_of(:time_zone)
      end

    end

    context "when export data are StopArea" do

      before do
        subject.references_type = "stop_area"
      end

      it "should be mandatory" do
        should_not validate_presence_of(:time_zone)
      end

    end

  end

end
