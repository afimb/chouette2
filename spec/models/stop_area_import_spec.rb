# -*- coding: utf-8 -*-
require 'spec_helper'

describe StopAreaImport do

   let(:valid_file) {
    csv_file = File.open(Rails.root.join("spec", "fixtures", "stop_area_import_valid.csv").to_s, "r")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }

  let(:invalid_file) {
    csv_file = File.open(Rails.root.join("spec", "fixtures", "stop_area_import_invalid.csv").to_s, "r")
    mock("CSV", :tempfile => csv_file, :original_filename => File.basename(csv_file), :path => File.path(csv_file) )
  }
  
  subject { StopAreaImport.new(:file => valid_file) }

  describe ".save" do

    it "should validate presence of file" do
      expect(StopAreaImport.new.save).to be_false
    end
    
    it "should import stop areas and create the right number of objects" do
      expect(StopAreaImport.new(:file => valid_file).save).to be_true
      expect(Chouette::StopArea.all.size).to eq(6)     
    end

    it "should not import vehicle_journeys and not create objects when vehicle journey at stops are not in ascendant order" do      
      expect(StopAreaImport.new(:file => invalid_file).save).to be_false
      expect(Chouette::StopArea.all.size).to eq(0)
    end   
    
  end

  describe ".load_imported_stop_areas" do

    # it "should return errors when stop_areas in file are invalid" do           
    #   stop_area_import = StopAreaImport.new(:referential => referential, :file => invalid_file)
    #   expect { stop_area_import.load_imported_stop_areas }.to raise_exception
    # end
  
    it "should load stop ateas" do
      expect(subject.load_imported_stop_areas.size).to eq(6)
      expect(subject.errors.messages).to eq({})
    end
    
  end

end
