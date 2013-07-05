require 'spec_helper'

describe Chouette::Kml::Exporter do

  subject { Chouette::Kml::Exporter.new }

  let(:zip_file_path) { "#{Rails.root}/tmp/exports/test.zip" }
  let(:line) { Factory(:line_with_stop_areas_having_parent) }

  describe "#export" do    

    it "should return a zip file with nothing inside with no objects in arguments" do
      subject.export(zip_file_path, {} )                   
      File.exists?(zip_file_path).should be_true
      puts ::Zip::ZipFile.open(zip_file_path).entries.inspect
      ::Zip::ZipFile.open(zip_file_path).size.should == 0
    end

    it "should return a zip file with the kml of the line inside with a line in arguments" do
      subject.export(zip_file_path, {:export_id => 1, :o => "line", :id => "#{line.id}" } )  
      File.exists?(zip_file_path).should be_true
      ::Zip::ZipFile.open(zip_file_path).size.should == 4
    end

  end
                              

end
