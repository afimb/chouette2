require 'spec_helper'

describe Referential do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:prefix) }
  it { should validate_presence_of(:time_zone) }

end

describe Chouette::StopArea do
  # check override methods
  
   subject {Factory(:stop_area)}
  
    it "should return referential projection " do
      subject.referential.projection_type='27572'
      subject.projection.should == subject.referential.projection_type
    end

    it "should return projection coordinates when referential has projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type='27572'
      subject.projection_x.should_not be_nil
      subject.projection_y.should_not be_nil
    end

    it "should return nil projection coordinates when referential has no projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type=nil
      subject.projection_x.should be_nil
      subject.projection_y.should be_nil
    end

end

describe Chouette::AccessPoint do
  # check override methods
  
   subject {Factory(:access_point)}
  
    it "should return referential projection " do
      subject.referential.projection_type='27572'
      subject.projection.should == subject.referential.projection_type
    end

    it "should return projection coordinates when referential has projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type='27572'
      subject.projection_x.should_not be_nil
      subject.projection_y.should_not be_nil
    end

    it "should return nil projection coordinates when referential has no projection" do
      subject.latitude = 45
      subject.longitude = 0
      subject.referential.projection_type=nil
      subject.projection_x.should be_nil
      subject.projection_y.should be_nil
    end

end