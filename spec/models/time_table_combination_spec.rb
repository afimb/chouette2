require 'spec_helper'

describe TimeTableCombination do
  let!(:source){ Factory(:time_table)}
  let!(:combined){Factory(:time_table)}
  subject {Factory.build(:time_table_combination)}
  
  it { should validate_presence_of :source_id }
  it { should validate_presence_of :combined_id }
  it { should validate_presence_of :operation }
  
  it { should ensure_inclusion_of(:operation).in_array(TimeTableCombination.operations) }

  
  describe "#combine" do
    context "when operation is union" do
      before(:each) do
        source.periods.clear
        source.dates.clear
        source.int_day_types = 508
        source.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,31))
        source.save
        combined.periods.clear
        combined.dates.clear
        combined.int_day_types = 508
        combined.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,15), :period_end => Date.new(2014,9,15))
        combined.save
        subject.operation = 'union'
        subject.source_id = source.id
        subject.combined_id = combined.id
        subject.combine
        source.reload
      end
      it "should add combined to source" do
        source.periods.size.should == 1
        source.periods[0].period_start.should == Date.new(2014,8,1)
        source.periods[0].period_end.should == Date.new(2014,9,15)
      end
    end
    context "when operation is intersect" do
      before(:each) do
        source.periods.clear
        source.dates.clear
        source.int_day_types = 508
        source.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,31))
        source.save
        combined.periods.clear
        combined.dates.clear
        combined.int_day_types = 508
        combined.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,15), :period_end => Date.new(2014,9,15))
        combined.save
        subject.operation = 'intersection'
        subject.source_id = source.id
        subject.combined_id = combined.id
        subject.combine
        source.reload
      end
      it "should intersect combined to source" do
        source.periods.size.should == 1
        source.periods[0].period_start.should == Date.new(2014,8,15)
        source.periods[0].period_end.should == Date.new(2014,8,31)
      end
    end
    context "when operation is disjoin" do
      before(:each) do
        source.periods.clear
        source.dates.clear
        source.int_day_types = 508
        source.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,31))
        source.save
        combined.periods.clear
        combined.dates.clear
        combined.int_day_types = 508
        combined.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,15), :period_end => Date.new(2014,9,15))
        combined.save
        subject.operation = 'disjunction'
        subject.source_id = source.id
        subject.combined_id = combined.id
        subject.combine
        source.reload
      end
      it "should disjoin combined to source" do
        source.periods.size.should == 1
        source.periods[0].period_start.should == Date.new(2014,8,1)
        source.periods[0].period_end.should == Date.new(2014,8,14)
      end
    end
 end
end

