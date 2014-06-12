# -*- coding: utf-8 -*-
require 'spec_helper'

describe VehicleJourneyImport do

  let(:file) { File.open(Rails.root.join("spec", "fixtures", "vehicle_journey_imports_valid.csv").to_s, "r") }  

  let!(:route) { create(:route) }
  let!(:other_route) { create(:route) }

  let!(:journey_pattern) { create(:journey_pattern, :route_id => route.id) }
  let!(:other_journey_pattern) { create(:journey_pattern, :route_id => route.id) }

  let!(:vehicle_journey1) { create(:vehicle_journey, :objectid => "vehicle_journey_1", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  let!(:vehicle_journey2) { create(:vehicle_journey, :objectid => "vehicle_journey_2", :route_id => route.id, :journey_pattern_id => other_journey_pattern.id) }
  let!(:vehicle_journey3) { create(:vehicle_journey, :objectid => "vehicle_journey_3", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  
  let!(:stop_area1) { create(:stop_area, :name => "Arrêt 1") }
  let!(:stop_area2) { create(:stop_area, :name => "Arrêt 2") }
  let!(:stop_area3) { create(:stop_area, :name => "Arrêt 3") }
  let!(:stop_area4) { create(:stop_area, :name => "Arrêt 4") }
  
  let!(:stop_point1) { create(:stop_point, :id => 1, :stop_area => stop_area1) }
  let!(:stop_point2) { create(:stop_point, :id => 2, :stop_area => stop_area2) }
  let!(:stop_point3) { create(:stop_point, :id => 3, :stop_area => stop_area3) }
  let!(:stop_point4) { create(:stop_point, :id => 4, :stop_area => stop_area4) }
  
  subject { VehicleJourneyImport.new(:route => route, :file => file) }

  before :each do
    route.stop_points = [stop_point1, stop_point2, stop_point3, stop_point4] 
    journey_pattern.stop_points = [stop_point1, stop_point2, stop_point3, stop_point4]
    other_journey_pattern.stop_points = [stop_point1, stop_point3, stop_point4]
  end

  describe ".save" do

    it "should validate presence of route" do
      expect(VehicleJourneyImport.new(:route => route).save).to be_false
    end

    it "should validate presence of file" do
      expect(VehicleJourneyImport.new(:file => file).save).to be_false
    end

    it "should import vehicle_journeys and create the right number of objects" do
      expect(VehicleJourneyImport.new(:file => file, :route => route).save).to be_true
    end
    
  end

  describe ".find_journey_pattern_schedule" do   

    it "should return journey pattern with same stop points" do          
      expect(subject.find_journey_pattern_schedule( { 1 => "9:00", 2 => "9:05", 3 => "9:10", 4 => "9:15"} )).to eq(journey_pattern)
      expect(subject.find_journey_pattern_schedule( { 1 => "9:00", 2 => nil, 3 => "9:10", 4 => "9:15"} )).to eq(other_journey_pattern)
    end

    it "should return new journey_pattern if no journey pattern with same stop points is founded" do      
      expect(subject.find_journey_pattern_schedule( { 1 => "9:00", 2 => "9:05", 3 => nil, 4 => "9:15"} )).to be_true
      expect(subject.find_journey_pattern_schedule( { 1 => "9:00", 2 => "9:05", 3 => nil, 4 => "9:15"} ).id).not_to eq(journey_pattern.id)
      expect(subject.find_journey_pattern_schedule( { 1 => "9:00", 2 => "9:05", 3 => nil, 4 => "9:15"} ).id).not_to eq(other_journey_pattern.id)
    end
    
  end

  describe ".load_imported_vehicle_journeys" do

    it "should return false when stop points in file are not the same in the route" do
      expect(VehicleJourneyImport.new(:route => other_route, :file => file).load_imported_vehicle_journeys).to eq([])
      expect(Chouette::VehicleJourney.all.size).to eq(3)
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(0)
    end

    it "should return false when vehicle journeys in file are invalid" do
      invalid_file = File.open(Rails.root.join("spec", "fixtures", "vehicle_journey_imports_with_vj_invalid.csv").to_s, "r")
      expect(VehicleJourneyImport.new(:route => other_route, :file => invalid_file).load_imported_vehicle_journeys).to eq([])
      expect(Chouette::VehicleJourney.all.size).to eq(3)
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(0)
    end

    it "should return false when vehicle journey at stops in file are invalid" do
      invalid_file = File.open(Rails.root.join("spec", "fixtures", "vehicle_journey_imports_with_vjas_invalid.csv").to_s, "r")
      expect(VehicleJourneyImport.new(:route => other_route, :file => invalid_file).load_imported_vehicle_journeys).to eq([])
      expect(Chouette::VehicleJourney.all.size).to eq(3)
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(0)
    end
    
    it "should load vehicle journeys" do
      expect(subject.load_imported_vehicle_journeys.size).to eq(3)
      expect(Chouette::VehicleJourney.all.collect(&:objectid)).to match_array([vehicle_journey1.objectid, vehicle_journey2.objectid, vehicle_journey3.objectid])
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(11)
    end
    
  end

  
  
end
