require 'spec_helper'

describe CsvImport, :type => :model do

 describe "#object_id_prefix" do

   it "should be included in import_options" do
     subject.object_id_prefix = "dummy"
     expect(subject.parameter_set["object_id_prefix"]).to eq("dummy")
   end

 end

end
