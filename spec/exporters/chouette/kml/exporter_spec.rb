require 'spec_helper'

describe Chouette::Kml::Exporter do

  # let(:referential) { Factory(:referential) }
  # subject { Chouette::Kml::Exporter.new(referential) }

  # let(:zip_file_path) { "#{Rails.root}/tmp/exports/test.zip" }
  # let(:line) {
  #   referential.switch
  #   Factory(:line_with_stop_areas_having_parent) }

  let(:kml_export){ Factory(:kml_export)}
  subject { Chouette::Kml::Exporter.new(first_referential, kml_export) }

  let(:tmp_path) { File.join( Rails.root, "tmp")}
  let(:exports_path) { File.join( tmp_path, "exports")}
  let(:zip_file_path) { File.join( exports_path, "test.zip")}
  let!(:line) { Factory(:line_with_stop_areas_having_parent) }
  let!(:line2) { Factory(:line_with_stop_areas_having_parent) }

  describe "#export" do
    before(:each) do
      Dir.mkdir( tmp_path) unless File.directory?( tmp_path)
      Dir.mkdir( exports_path) unless File.directory?( exports_path)
    end

    it "should return a zip file with nothing inside with no objects in arguments" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line"} )
      expect(File.exists?(zip_file_path)).to be_truthy
      expect(::Zip::File.open(zip_file_path).size).to eq(6)
    end

    it "should return a zip file with 4 kml files" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id}" } )
      expect(File.exists?(zip_file_path)).to be_truthy
      expect(::Zip::File.open(zip_file_path).size).to eq(4)
    end

    it "should return a zip file with 6 kml files" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id},#{line2.id}" } )
      expect(File.exists?(zip_file_path)).to be_truthy
      expect(::Zip::File.open(zip_file_path).size).to eq(6)
    end

    it "should return a zip file with 6 kml files" do
      subject.export(zip_file_path, {:export_id => 1, :o => "", :id => "" } )
      expect(File.exists?(zip_file_path)).to be_truthy
      expect(::Zip::File.open(zip_file_path).size).to eq(6)
    end

   end


end
