# require 'spec_helper'

# describe ImportTask, :type => :model do

#   subject { build :import_task }

#   describe ".new" do

#     it "should use type attribute to create a subclass" do
#       expect(ImportTask.new(:format => "Neptune")).to be_an_instance_of(NeptuneImport)
#       expect(ImportTask.new(:format => "Gtfs")).to be_an_instance_of(GtfsImport)
#       expect(ImportTask.new(:format => "Netex")).to be_an_instance_of(NetexImport)
#       expect(ImportTask.new(:format => "Csv")).to be_an_instance_of(CsvImport)

#       expect(NeptuneImport.new).to be_an_instance_of(NeptuneImport)
#       expect(GtfsImport.new).to be_an_instance_of(GtfsImport)
#       expect(NetexExperimentalImport.new).to be_an_instance_of(NetexExperimentalImport)
#       expect(CsvImport.new).to be_an_instance_of(CsvImport)
#     end

#   end

#   describe "#delayed_import" do
#     before(:each) do
#       allow(subject).to receive_messages( :delay => double( :import => true))
#     end
#     it "should call delay#import" do
#       expect(subject.delay).to receive( :import)
#       subject.send :delayed_import
#     end
#   end

#   describe ".create" do
#     before(:each) do
#       allow(subject).to receive_messages( :save_resources => true )
#     end
#     it "should call save_resource" do
#       expect(subject).to receive( :save_resources)
#       subject.send :save
#     end
#     it "should update file_path with #saved_resources" do
#       subject.send :save
#       expect(ImportTask.find( subject.id).file_path).to eq(subject.send( :saved_resources))
#     end
#     it "should have a compliance_check_task" do
#       subject.send :save
#       expect(ImportTask.find( subject.id).compliance_check_task).not_to be_nil
#     end
#   end

#   describe "#compliance_check_task" do
#     let(:rule_parameter_set){ Factory( :rule_parameter_set) }
#     let(:import_task){ Factory(:import_task, :rule_parameter_set_id => rule_parameter_set.id) }
#     let(:compliance_check_task){ import_task.compliance_check_task }

#     it "should have same #referential as import_task" do
#       expect(compliance_check_task.referential).to eq(import_task.referential)
#     end

#     it "should have same #rule_parameter_set_id as import_task" do
#       expect(compliance_check_task.rule_parameter_set_id).to eq(import_task.rule_parameter_set_id)
#     end

#     it "should have same #user_id as import_task" do
#       expect(compliance_check_task.user_id).to eq(import_task.user_id)
#     end

#     it "should have same #user_name as import_task" do
#       expect(compliance_check_task.user_name).to eq(import_task.user_name)
#     end
#   end

#   describe "#file_path_extension" do
#     let(:import_task){ Factory(:import_task) }
#     context "zip file to import" do
#       before(:each) do
#         import_task.file_path = "aaa/bbb.zip"
#       end
#       it "should return zip" do
#         expect(import_task.file_path_extension).to eq("zip")
#       end
#     end
#     context "xml file to import" do
#       before(:each) do
#         import_task.file_path = "aaa/bbb.xml"
#       end
#       it "should return xml" do
#         expect(import_task.file_path_extension).to eq("xml")
#       end
#     end
#     context "csv file to import" do
#       before(:each) do
#         import_task.file_path = "aaa/bbb.csv"
#       end
#       it "should return csv" do
#         expect(import_task.file_path_extension).to eq("basic")
#       end
#     end

#   end

#   context "options attributes" do
#     let(:import_task){ Factory(:import_task) }
#     describe "#no_save" do
#       it "should read parameter_set['no_save']" do
#         import_task.parameter_set[ "no_save"] = "dummy"
#         expect(import_task.no_save).to eq("dummy")
#       end
#     end
#     describe "#format" do
#       it "should read parameter_set['format']" do
#         import_task.parameter_set[ "format"] = "dummy"
#         expect(import_task.format).to eq("dummy")
#       end
#     end
#     describe "#file_path" do
#       it "should read parameter_set['file_path']" do
#         import_task.parameter_set[ "file_path"] = "dummy"
#         expect(import_task.file_path).to eq("dummy")
#       end
#     end
#     describe "#no_save=" do
#       it "should read parameter_set['no_save']" do
#         import_task.no_save = "dummy"
#         expect(import_task.parameter_set[ "no_save"]).to eq(false)
#       end
#     end
#     describe "#format=" do
#       it "should read parameter_set['format']" do
#         import_task.format = "dummy"
#         expect(import_task.parameter_set[ "format"]).to eq("dummy")
#       end
#     end
#     describe "#file_path=" do
#       it "should read parameter_set['file_path']" do
#         import_task.file_path = "dummy"
#         expect(import_task.parameter_set[ "file_path"]).to eq("dummy")
#       end
#     end
#   end

#   describe "#chouette_command" do
#     it "should be a Chouette::Command instance" do
#       expect(subject.send( :chouette_command).class).to eq(Chouette::Command)
#     end
#     it "should have schema same as referential.slug" do
#       expect(subject.send( :chouette_command).schema).to eq(subject.referential.slug)
#     end
#   end

#   describe "#import" do
#     let(:import_task){ Factory(:import_task) }
#     let(:chouette_command) { "dummy" }
#     context "for failing import" do
#       before(:each) do
#         allow(chouette_command).to receive( :run!).and_raise( "dummy")
#         allow(import_task).to receive_messages( :chouette_command => chouette_command)
#       end
#       it "should have status 'failed'" do
#         import_task.import
#         expect(import_task.status).to eq("failed")
#       end
#       it "should have status 'failed' for compliance_check_task" do
#         import_task.import
#         expect(import_task.compliance_check_task.status).to eq("failed")
#       end
#     end
#     context "for successful import" do
#       before(:each) do
#         allow(import_task).to receive_messages( :chouette_command => double( :run! => true ))
#       end
#       it "should have status 'completed'" do
#         import_task.import
#         expect(import_task.status).to eq("completed")
#       end
#       it "should have status 'completed' for compliance_check_task" do
#         import_task.import
#         expect(import_task.status).to eq("completed")
#       end
#     end
#   end

#   describe "#import" do
#     let(:import_task){ Factory(:import_task) }
#     let(:command_args){ "dummy" }
#     before(:each) do
#       allow(import_task).to receive_messages( :chouette_command => double( :run! => true ))
#       allow(import_task).to receive_messages( :chouette_command_args => command_args)
#     end
#     it "should call chouette_command.run! with :c => 'import', :id => id" do
#       expect(import_task.send( :chouette_command)).to receive( :run! ).with(  command_args)
#       import_task.import
#     end
#   end

# end
