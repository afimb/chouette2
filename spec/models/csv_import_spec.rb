require 'spec_helper'

describe CsvImport do

 describe "#object_id_prefix" do

   it "should be included in import_options" do
     subject.object_id_prefix = "dummy"
     subject.parameter_set["object_id_prefix"].should == "dummy"
   end

 end

end
