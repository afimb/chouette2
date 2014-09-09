# -*- coding: utf-8 -*-
require 'spec_helper'

describe VehicleJourneyImport do

  def update_csv_file_with_factory_data(filename)
    csv_file = CSV.open("/tmp/#{filename}", "wb",{ :col_sep => ";"}) do |csv|
      counter = 0
      CSV.foreach( Rails.root.join("spec", "fixtures", "#{filename}").to_s , {:col_sep => ";"}) do |row|
        if counter < 6
          csv << row
        else
          csv << ( row[0] = route.stop_points[counter - 6].id; row)          
        end
        counter += 1
      end

    end

    File.open("/tmp/#{filename}")
  end
  
  let!(:route) { create(:route) }
  let!(:other_route) { create(:route) }

  let!(:journey_pattern) { create(:journey_pattern, :route => route) }
  let!(:other_journey_pattern) { create(:journey_pattern_even, :route => route) }

  let!(:vehicle_journey1) { create(:vehicle_journey_common, :objectid => "import:VehicleJourney:1", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  let!(:vehicle_journey2) { create(:vehicle_journey_common, :objectid => "import:VehicleJourney:2", :route_id => route.id, :journey_pattern_id => other_journey_pattern.id) }
  let!(:vehicle_journey3) { create(:vehicle_journey_common, :objectid => "import:VehicleJourney:3", :route_id => route.id, :journey_pattern_id => journey_pattern.id) }
  
  let!(:stop_point0) { route.stop_points[0] }
  let!(:stop_point1) { route.stop_points[1] }
  let!(:stop_point2) { route.stop_points[2] }
  let!(:stop_point3) { route.stop_points[3] }
  let!(:stop_point4) { route.stop_points[4] }

  
  # Must use uploaded file and not classical ruby File!
  let(:valid_file) {
    csv_file = update_csv_file_with_factory_data("vehicle_journey_imports_valid.csv")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }

  let(:invalid_file_on_vj) {
    csv_file = update_csv_file_with_factory_data("vehicle_journey_imports_with_vj_invalid.csv")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }

  let(:invalid_file_on_vjas) {
    csv_file = update_csv_file_with_factory_data("vehicle_journey_imports_with_vjas_invalid.csv")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }

  let(:invalid_file_on_vjas_object) {
    csv_file = update_csv_file_with_factory_data("vehicle_journey_imports_with_vjas_bad_order.csv")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }
  
  subject { VehicleJourneyImport.new(:route => route, :file => valid_file) } 

  describe ".save" do

    it "should validate presence of route" do
      expect(VehicleJourneyImport.new(:route => route).save).to be_false
    end

    it "should validate presence of file" do
      expect(VehicleJourneyImport.new(:file => valid_file).save).to be_false
    end

    it "should import vehicle_journeys and create the right number of objects" do
      expect(VehicleJourneyImport.new(:file => valid_file, :route => route).save).to be_true
      expect(Chouette::VehicleJourney.all.size).to eq(4)
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(17)
    end

    it "should not import vehicle_journeys and not create objects when vehicle journey at stops are not in ascendant order" do      
      expect(VehicleJourneyImport.new(:route => route, :file => invalid_file_on_vjas_object).save).to be_false
      expect(Chouette::VehicleJourney.all.size).to eq(3)
      expect(Chouette::VehicleJourneyAtStop.all.size).to eq(0)
    end
    
    # it "should not import vehicle_journeys and not create objects with invalid file" do
    #   expect(VehicleJourneyImport.new(:file => invalid_file_on_vj, :route => route).save).to be_false
    #   expect(Chouette::VehicleJourney.all.size).to eq(3)
    #   expect(Chouette::VehicleJourneyAtStop.all.size).to eq(0)
    # end
    
  end

  describe ".find_journey_pattern_schedule" do   

    it "should return journey pattern with same stop points" do          
      expect(subject.find_journey_pattern_schedule( 1, { stop_point0.id => "9:00", stop_point1.id => "9:05", stop_point2.id => "9:10", stop_point3.id => "9:15", stop_point4.id => "9:20"} )).to eq(journey_pattern)
      expect(subject.find_journey_pattern_schedule( 1, { stop_point1.id => "9:00", stop_point3.id => "9:10" } )).to eq(other_journey_pattern)
    end

    it "should return new journey_pattern if no journey pattern with same stop points is founded" do      
      expect(subject.find_journey_pattern_schedule( 1, { stop_point0.id => "9:00", stop_point1.id => "9:05", stop_point2.id => nil, stop_point3.id => "9:15", stop_point4.id => "9:20"} )).to be_true
      expect(subject.find_journey_pattern_schedule( 1, { stop_point0.id => "9:00", stop_point1.id => "9:05", stop_point2.id => nil, stop_point3.id => "9:15", stop_point4.id => "9:20"} ).id).not_to eq(journey_pattern.id)
      expect(subject.find_journey_pattern_schedule( 1, { stop_point0.id => "9:00", stop_point1.id => "9:05", stop_point2.id => nil, stop_point3.id => "9:15", stop_point4.id => "9:20"} ).id).not_to eq(other_journey_pattern.id)
    end
    
  end

  describe ".load_imported_vehicle_journeys" do

    it "should return false when stop points in file are not the same in the route" do
      vehicle_journey_import = VehicleJourneyImport.new(:route => other_route, :file => valid_file)
      expect { vehicle_journey_import.load_imported_vehicle_journeys }.to raise_exception
    end

    # it "should return errors when vehicle journeys in file are invalid" do            
    #   vehicle_journey_import = VehicleJourneyImport.new(:route => route, :file => invalid_file_on_vj)
      
    #   expect { vehicle_journey_import.load_imported_vehicle_journeys }.to raise_error
    # end

    it "should return errors when vehicle journey at stops in file are invalid" do           
      vehicle_journey_import = VehicleJourneyImport.new(:route => route, :file => invalid_file_on_vjas)
      expect { vehicle_journey_import.load_imported_vehicle_journeys }.to raise_exception
    end

    it "should return errors when vehicle journey at stops are not in ascendant order" do    
      vehicle_journey_import = VehicleJourneyImport.new(:route => route, :file => invalid_file_on_vjas_object)
      expect(vehicle_journey_import.load_imported_vehicle_journeys.size).to eq(3)
      expect(vehicle_journey_import.errors.messages).to be_empty
    end
    
    it "should load vehicle journeys" do
      expect(subject.load_imported_vehicle_journeys.size).to eq(4)
      expect(subject.errors.messages).to eq({})
    end
    
  end

  
  
end
