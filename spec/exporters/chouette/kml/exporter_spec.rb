require 'spec_helper'

describe Chouette::Kml::Exporter do

  # # let(:referential) { create(:referential) }
  # # subject { Chouette::Kml::Exporter.new(referential) }

  # # let(:zip_file_path) { "#{Rails.root}/tmp/exports/test.zip" }
  # # let(:line) {
  # #   referential.switch
  # #   create(:line_with_stop_areas_having_parent) }

  # let(:kml_export){ create(:kml_export)}
  # subject { Chouette::Kml::Exporter.new(first_referential, kml_export) }

  # let(:tmp_path) { File.join( Rails.root, "tmp")}
  # let(:exports_path) { File.join( tmp_path, "exports")}
  # let(:zip_file_path) { File.join( exports_path, "test.zip")}
  # let!(:line) { create(:line_with_stop_areas_having_parent) }
  # let!(:line2) { create(:line_with_stop_areas_having_parent) }

  # describe "#export" do
  #   before(:each) do
  #     Dir.mkdir( tmp_path) unless File.directory?( tmp_path)
  #     Dir.mkdir( exports_path) unless File.directory?( exports_path)
  #   end

  #   it "should return a zip file with nothing inside with no objects in arguments" do
  #     subject.export(zip_file_path, {:export_id => 1, :o => "line"} )
  #     expect(File.exists?(zip_file_path)).to be_truthy
  #     expect(::Zip::File.open(zip_file_path).size).to eq(8)
  #   end

  #   it "should return a zip file with 5 kml files" do
  #     subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id}" } )
  #     expect(File.exists?(zip_file_path)).to be_truthy
  #     expect(::Zip::File.open(zip_file_path).size).to eq(5)
  #   end

  #   it "should return a zip file with 8 kml files" do
  #     subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id},#{line2.id}" } )
  #     expect(File.exists?(zip_file_path)).to be_truthy
  #     expect(::Zip::File.open(zip_file_path).size).to eq(8)
  #   end

  #   it "should return a zip file with 8 kml files" do
  #     subject.export(zip_file_path, {:export_id => 1, :o => "", :id => "" } )
  #     expect(File.exists?(zip_file_path)).to be_truthy
  #     expect(::Zip::File.open(zip_file_path).size).to eq(8)
  #   end

  #  end


end
