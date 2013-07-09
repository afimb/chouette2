require 'spec_helper'

describe Chouette::Kml::Exporter do

  # let(:referential) { Factory(:referential) }
  # subject { Chouette::Kml::Exporter.new(referential) }

  # let(:zip_file_path) { "#{Rails.root}/tmp/exports/test.zip" }
  # let(:line) {
  #   referential.switch
  #   Factory(:line_with_stop_areas_having_parent) }

  subject { Chouette::Kml::Exporter.new(first_referential) }

  let(:zip_file_path) { "#{Rails.root}/tmp/exports/test.zip" }
  let!(:line) { Factory(:line_with_stop_areas_having_parent) }
  let!(:line2) { Factory(:line_with_stop_areas_having_parent) }

  describe "#export" do    

    it "should return a zip file with nothing inside with no objects in arguments" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line"} )                   
      File.exists?(zip_file_path).should be_true
      ::Zip::ZipFile.open(zip_file_path).size.should == 6
    end

    it "should return a zip file with 4 kml files" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id}" } )  
      File.exists?(zip_file_path).should be_true
      ::Zip::ZipFile.open(zip_file_path).size.should == 4
    end

    it "should return a zip file with 6 kml files" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id},#{line2.id}" } )  
      File.exists?(zip_file_path).should be_true
      ::Zip::ZipFile.open(zip_file_path).size.should == 6
    end

  end
                              

end
