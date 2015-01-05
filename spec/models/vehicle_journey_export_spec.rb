# -*- coding: utf-8 -*-
require 'spec_helper'

describe VehicleJourneyExport, :type => :model do
  
  let!(:route) { create(:route) }
  let!(:other_route) { create(:route) }

  let!(:journey_pattern) { create(:journey_pattern, :route => route) }
  let!(:other_journey_pattern) { create(:journey_pattern_even, :route => route) }

  let!(:vehicle_journey1) { create(:vehicle_journey_common, :objectid => "export:VehicleJourney:1", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  let!(:vehicle_journey2) { create(:vehicle_journey_common, :objectid => "export:VehicleJourney:2", :route_id => route.id, :journey_pattern_id => other_journey_pattern.id) }
  let!(:vehicle_journey3) { create(:vehicle_journey_common, :objectid => "export:VehicleJourney:3", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  
  let!(:stop_point0) { route.stop_points[0] }
  let!(:stop_point1) { route.stop_points[1] }
  let!(:stop_point2) { route.stop_points[2] }
  let!(:stop_point3) { route.stop_points[3] }
  let!(:stop_point4) { route.stop_points[4] }

  let!(:time_table) { create(:time_table)}
  
  subject { VehicleJourneyExport.new(:vehicle_journeys => route.vehicle_journeys, :route => route) } 

  describe ".tt_day_types" do   

    it "should return no day_type" do
      time_table.int_day_types = 0
      expect(subject.tt_day_types(time_table)).to eq("..............")
    end

    it "should return all days" do
      time_table.int_day_types = 4|8|16|32|64|128|256
      expect(subject.tt_day_types(time_table)).to eq("LuMaMeJeVeSaDi")
    end
    
  end

  describe ".tt_periods" do   

    it "should return empty period" do
      time_table.periods.clear
      expect(subject.tt_periods(time_table)).to eq("")
    end

    it "should return periods" do
      time_table.periods.clear
      time_table.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,8))
      expect(subject.tt_periods(time_table)).to eq("[2014-08-01 -> 2014-08-08] ")
    end
    
  end
  
  describe ".tt_included_days" do   

    it "should return empty included dates" do
      time_table.dates.clear
      expect(subject.tt_peculiar_days(time_table)).to eq("")
    end

    it "should return included date" do
      time_table.dates.clear
      time_table.dates << Chouette::TimeTableDate.new(:date => Date.new(2014,8,1), :in_out => true)
      expect(subject.tt_peculiar_days(time_table)).to eq("2014-08-01 ")
    end
    
  end

  describe ".tt_excluded_days" do   

    it "should return empty excluded dates" do
      time_table.dates.clear
      expect(subject.tt_excluded_days(time_table)).to eq("")
    end

    it "should return excluded date" do
      time_table.dates.clear
      time_table.dates << Chouette::TimeTableDate.new(:date => Date.new(2014,8,1), :in_out => false)
      expect(subject.tt_excluded_days(time_table)).to eq("2014-08-01 ")
    end
    
  end
  
end
