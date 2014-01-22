require 'spec_helper'

describe GtfsImport do

 describe "#object_id_prefix" do

   it "should be included in import_options" do
     subject.object_id_prefix = "dummy"
     subject.parameter_set["object_id_prefix"].should  == "dummy"
   end

 end

 describe "#max_distance_for_commercial" do

   it "should be included in import_options" do
     subject.max_distance_for_commercial = 300
     subject.parameter_set["max_distance_for_commercial"].should == 300
   end

 end

 describe "#max_distance_for_connection_link" do

   it "should be included in import_options" do
     subject.max_distance_for_connection_link = 300
     subject.parameter_set["max_distance_for_connection_link"].should == 300
   end

 end

 describe "#ignore_last_word" do

   it "should be included in import_options" do
     subject.ignore_last_word = true
     subject.parameter_set["ignore_last_word"].should == true
   end

 end

 describe "#ignore_end_chars" do

   it "should be included in import_options" do
     subject.ignore_end_chars = 2
     subject.parameter_set["ignore_end_chars"].should == 2
   end

 end

end
