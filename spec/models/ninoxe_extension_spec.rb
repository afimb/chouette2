require 'spec_helper'

describe Chouette::StopArea do
  # check override methods

   subject {create(:stop_area)}

    it "should return referential projection " do
      subject.referential.projection_type='27572'
      expect(subject.projection).to eq(subject.referential.projection_type)
    end

    it "should return projection coordinates when referential has projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type='27572'
      expect(subject.projection_x).not_to be_nil
      expect(subject.projection_y).not_to be_nil
    end

    it "should return nil projection coordinates when referential has no projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type=nil
      expect(subject.projection_x).to be_nil
      expect(subject.projection_y).to be_nil
    end

end

describe Chouette::AccessPoint do
  # check override methods

   subject {create(:access_point)}

    it "should return referential projection " do
      subject.referential.projection_type='27572'
      expect(subject.projection).to eq(subject.referential.projection_type)
    end

    it "should return projection coordinates when referential has projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type='27572'
      expect(subject.projection_x).not_to be_nil
      expect(subject.projection_y).not_to be_nil
    end

    it "should return nil projection coordinates when referential has no projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type=nil
      expect(subject.projection_x).to be_nil
      expect(subject.projection_y).to be_nil
    end

end
