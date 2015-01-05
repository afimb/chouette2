# require 'spec_helper'

# describe ComplianceCheckTask, :type => :model do

#   subject { Factory( :compliance_check_task ) }

#   RSpec::Matchers.define :be_log_message do |expected|
#     match do |actual|
#       actual and expected.all? { |k,v| actual[k.to_s] == v }
#     end
#   end


#   describe "#any_error_severity_failure?" do
#     context "when compliance_check_results empty" do
#       before(:each) do
#         subject.compliance_check_results = []
#       end
#       it "does return false" do
#         expect(subject.any_error_severity_failure?).to be_falsey
#       end
#     end
#     context "when compliance_check_results contains a error_severity_failure" do
#       let( :valid_result){ Factory.build( :compliance_check_result) }
#       let( :invalid_result){ Factory.build( :compliance_check_result, :severity => "error", :status => "nok") }
#       before(:each) do
#         subject.compliance_check_results = [ valid_result, invalid_result]
#       end
#       it "does return true" do
#         expect(subject.any_error_severity_failure?).to be_truthy
#       end
#     end
#     context "when compliance_check_results contains no error_severity_failure" do
#       let( :valid_result){ Factory.build( :compliance_check_result) }
#       before(:each) do
#         subject.compliance_check_results = [ valid_result]
#       end
#       it "does return false" do
#         expect(subject.any_error_severity_failure?).to be_falsey
#       end
#     end
#   end

#   describe "#destroy" do
#     let(:import_task){ Factory( :import_task )}
#     context "with an import_task" do
#         before(:each) do
#           subject.import_task = import_task
#         end
#         it "should destroy import_task" do
#           subject.destroy
#           expect(ImportTask.exists?( import_task.id)).to be_falsey
#         end
#     end
#     context "without any import_task" do
#         before(:each) do
#           subject.import_task = nil
#         end
#         it "should not raise exception" do
#           subject.destroy
#           expect(subject).to be_destroyed
#         end
#     end
#   end

#   describe "#levels" do
#     let(:import_task){ Factory( :import_task )}
#     context "when validation is without import" do
#       it "should not return levels 1 and 2" do
#         expect(subject.levels.include?(1)).to be_falsey
#         expect(subject.levels.include?(2)).to be_falsey
#       end
#       context "when parameter_set is defined" do
#         before(:each) do
#           subject.parameter_set = "dummy"
#         end
#         it "should return level 3" do
#           expect(subject.levels.include?(3)).to be_truthy
#         end
#       end
#       context "when parameter_set is not defined" do
#         before(:each) do
#           subject.parameter_set = nil
#         end
#         it "should not return level 3" do
#           expect(subject.levels.include?(3)).not_to be_truthy
#         end
#       end
#     end
#     context "when validation is done with an import" do
#       before(:each) do
#         subject.import_task = import_task
#       end
#       it "should return levels 1 and 2" do
#         expect(subject.levels.include?(1)).to be_truthy
#         expect(subject.levels.include?(2)).to be_truthy
#       end
#       context "when parameter_set is defined" do
#         before(:each) do
#           subject.parameter_set = "dummy"
#         end
#         it "should return level 3" do
#           expect(subject.levels.include?(3)).to be_truthy
#         end
#       end
#       context "when parameter_set is not defined" do
#         before(:each) do
#           subject.parameter_set = nil
#         end
#         it "should not return level 3" do
#           expect(subject.levels.include?(3)).not_to be_truthy
#         end
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

#   describe "#validate" do
#     let(:compliance_check_task){ Factory(:compliance_check_task) }
#     let(:chouette_command) { "dummy" }
#     context "for failing validation" do
#       before(:each) do
#         allow(chouette_command).to receive( :run!).and_raise( "dummy")
#         allow(compliance_check_task).to receive_messages( :chouette_command => chouette_command)
#       end
#       it "should have status 'failed'" do
#         compliance_check_task.validate
#         expect(compliance_check_task.status).to eq("failed")
#       end
#     end
#     context "for successful validation" do
#       before(:each) do
#         allow(compliance_check_task).to receive_messages( :chouette_command => double( :run! => true ))
#       end
#       it "should have status 'completed'" do
#         compliance_check_task.validate
#         expect(compliance_check_task.status).to eq("completed")
#       end
#     end
#   end

#   describe "#validate" do
#     let(:compliance_check_task){ Factory(:compliance_check_task) }
#     let(:command_args){ "dummy" }
#     before(:each) do
#       allow(compliance_check_task).to receive_messages( :chouette_command => double( :run! => true ))
#       allow(compliance_check_task).to receive_messages( :chouette_command_args => command_args)
#     end
#     it "should call chouette_command.run! with :c => 'import', :id => id" do
#       expect(compliance_check_task.send( :chouette_command)).to receive( :run! ).with(  command_args)
#       compliance_check_task.validate
#     end
#   end

#   describe "#delayed_validate" do
#     let( :import_task){ Factory.build(:import_task) }
#     before(:each) do
#       allow(subject).to receive_messages( :delay => double( :validate => true))
#     end
#     it "should not call delay#validate if import_task defined" do
#       subject.import_task = import_task
#       expect(subject.delay).not_to receive( :validate)
#       subject.delayed_validate
#     end
#     it "should call delay#validate if import_task blank" do
#       subject.import_task = nil
#       expect(subject.delay).to receive( :validate)
#       subject.delayed_validate
#     end

#   end

#   describe "#define_default_attributes" do
#     it "should keep status if defined" do
#       subject.status = "dummy"
#       subject.define_default_attributes
#       expect(subject.status).to eq("dummy")
#     end
#     it "should set status to pending if not defined" do
#       subject.status = nil
#       subject.define_default_attributes
#       expect(subject.status).to eq("pending")
#     end
#     context "when rule_parameter_set is nil" do
#       before(:each) do
#         allow(subject).to receive_messages( :rule_parameter_set => nil)
#         subject.parameter_set = "dummy"
#         subject.parameter_set_name = "dummy"
#       end
#       it "should keep parameter_set_name" do
#         subject.define_default_attributes
#         expect(subject.parameter_set_name).to eq("dummy")
#       end
#       it "should keep parameter_set" do
#         subject.define_default_attributes
#         expect(subject.parameter_set).to eq("dummy")
#       end
#     end
#     context "when rule_parameter_set is defined" do
#       let( :rule_parameter_set ){ Factory( :rule_parameter_set ) }
#       before(:each) do
#         allow(subject).to receive_messages( :rule_parameter_set => rule_parameter_set)
#         subject.parameter_set = "dummy"
#         subject.parameter_set_name = "dummy"
#       end
#       it "should set parameter_set_name to rule_parameter_set.name" do
#         subject.define_default_attributes
#         expect(subject.parameter_set_name).to eq(rule_parameter_set.name)
#       end
#       it "should keep set parameter_set to rule_parameter_set.parameters" do
#         subject.define_default_attributes
#         expect(subject.parameter_set).to eq(rule_parameter_set.parameters)
#       end
#     end
#   end

#   describe "#rule_parameter_set" do
#     context "when rule_parameter_set_id is blank" do
#       before(:each) do
#         subject.rule_parameter_set_id = ""
#       end
#       it "should return nil" do
#         expect(subject.rule_parameter_set).to be_nil
#       end
#     end
#     context "when rule_parameter_set_id is not blank" do
#       let( :rule_parameter_set ){ Factory( :rule_parameter_set ) }
#       before(:each) do
#         subject.rule_parameter_set_id = rule_parameter_set.id
#       end
#       it "should return rule_parameter_set instance" do
#         expect(subject.rule_parameter_set).to eq(rule_parameter_set)
#       end
#     end
#   end

#   describe "#rule_parameter_set_archived" do
#     context "when parameter_set is blank" do
#       before(:each) do
#         subject.parameter_set = nil
#       end
#       it "should return nil" do
#         expect(subject.rule_parameter_set_archived).to be_nil
#       end
#     end
#     context "when parameter_set is blank" do
#       before(:each) do
#         subject.parameter_set = { :speed => 30, :distance => 5 }
#       end
#       it "should return RuleParameterSet#parameters same as parameter_set" do
#         expect(subject.rule_parameter_set_archived.parameters).to eq(subject.parameter_set)
#       end
#       it "should return RuleParameterSet#name same as parameter_set_name" do
#         expect(subject.rule_parameter_set_archived.name).to eq(subject.parameter_set_name)
#       end
#     end

#   end

# #  describe "#validate" do
# #
# #    before(:each) do
# #      subject.stub :validator => mock(:validate => true)
# #    end
# #
# #    it "should create a ComplianceCheckResult :started when started" do
# #      subject.validate
# #      subject.compliance_check_results.first.should be_log_message(:key => "started")
# #    end
# #
# #    it "should create a ComplianceCheckResult :completed when completed" do
# #      subject.validate
# #      subject.compliance_check_results.last.should be_log_message(:key => "completed")
# #    end
# #
# #    it "should create a ComplianceCheckResult :failed when failed" do
# #      pending
# #      # subject.loader.stub(:export).and_raise("export failed")
# #      subject.validate
# #      subject.compliance_check_results.last.should be_log_message(:key => "failed")
# #    end
# #
# #  end

#   describe ".create" do
#     let( :new_compliance_check_task){ Factory.build( :compliance_check_task) }

#     it "should call #define_default_attributes" do
#       expect(new_compliance_check_task).to receive( :define_default_attributes)
#       new_compliance_check_task.save
#     end

#     it "should call #delayed_validate" do
#       expect(new_compliance_check_task).not_to receive( :delayed_validate)
#       new_compliance_check_task.save
#     end

#   end

#   it_behaves_like TypeIdsModelable do
#     let(:type_ids_model) { subject}
#   end

# end

