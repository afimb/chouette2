require 'spec_helper'

describe Chouette::TimeTablePeriod, :type => :model do

  let!(:time_table) { create(:time_table)}
  subject { create(:time_table_period ,:time_table => time_table, :period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,6) ) }
  let!(:p2) {create(:time_table_period ,:time_table => time_table, :period_start => Date.new(2014,7,6), :period_end => Date.new(2014,7,14) ) } 

  it { is_expected.to validate_presence_of :period_start }
  it { is_expected.to validate_presence_of :period_end }
  
  describe "#overlap" do
    context "when periods intersect, " do
      it "should detect period overlap" do
         expect(subject.overlap?(p2)).to be_truthy
         expect(p2.overlap?(subject)).to be_truthy
      end
    end
    context "when periods don't intersect, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,7)
      end
      it "should not detect period overlap" do
         expect(subject.overlap?(p2)).to be_falsey
         expect(p2.overlap?(subject)).to be_falsey
      end
    end
    context "when period 1 contains period 2, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,1)
        p2.period_end = Date.new(2014,7,6)
      end
      it "should detect period overlap" do
         expect(subject.overlap?(p2)).to be_truthy
         expect(p2.overlap?(subject)).to be_truthy
      end
    end
  end
  describe "#contains" do
    context "when periods intersect, " do
      it "should not detect period inclusion" do
         expect(subject.contains?(p2)).to be_falsey
         expect(p2.contains?(subject)).to be_falsey
      end
    end
    context "when periods don't intersect, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,7)
      end
      it "should not detect period inclusion" do
         expect(subject.contains?(p2)).to be_falsey
         expect(p2.contains?(subject)).to be_falsey
      end
    end
    context "when period 1 contains period 2, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,1)
        p2.period_end = Date.new(2014,7,6)
      end
      it "should detect period inclusion" do
         expect(subject.contains?(p2)).to be_truthy
         expect(p2.contains?(subject)).to be_falsey
      end
    end
  end
end
