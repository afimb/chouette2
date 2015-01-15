require 'spec_helper'

describe TimeTableCombination, :type => :model do
  let!(:source){ Factory(:time_table)}
  let!(:combined){Factory(:time_table)}
  subject {Factory.build(:time_table_combination)}
  
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
        expect(source.periods.size).to eq(1)
        expect(source.periods[0].period_start).to eq(Date.new(2014,8,1))
        expect(source.periods[0].period_end).to eq(Date.new(2014,9,15))
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
        expect(source.periods.size).to eq(1)
        expect(source.periods[0].period_start).to eq(Date.new(2014,8,15))
        expect(source.periods[0].period_end).to eq(Date.new(2014,8,31))
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
        expect(source.periods.size).to eq(1)
        expect(source.periods[0].period_start).to eq(Date.new(2014,8,1))
        expect(source.periods[0].period_end).to eq(Date.new(2014,8,14))
      end
    end
 end
end

