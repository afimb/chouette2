require 'spec_helper'

describe ComplianceCheckTask do

  subject { Factory( :compliance_check_task ) }

  RSpec::Matchers.define :be_log_message do |expected|
    match do |actual|
      actual and expected.all? { |k,v| actual[k.to_s] == v }
    end
  end


  describe "#any_error_severity_failure?" do
    context "when compliance_check_results empty" do
      before(:each) do
        subject.compliance_check_results = []
      end
      it "does return false" do
        subject.any_error_severity_failure?.should be_false
      end
    end
    context "when compliance_check_results contains a error_severity_failure" do
      let( :valid_result){ Factory.build( :compliance_check_result) }
      let( :invalid_result){ Factory.build( :compliance_check_result, :severity => "error", :status => "nok") }
      before(:each) do
        subject.compliance_check_results = [ valid_result, invalid_result]
      end
      it "does return true" do
        subject.any_error_severity_failure?.should be_true
      end
    end
    context "when compliance_check_results contains no error_severity_failure" do
      let( :valid_result){ Factory.build( :compliance_check_result) }
      before(:each) do
        subject.compliance_check_results = [ valid_result]
      end
      it "does return false" do
        subject.any_error_severity_failure?.should be_false
      end
    end
  end

  describe "#destroy" do
    let(:import_task){ Factory( :import_task )}
    context "with an import_task" do
        before(:each) do
          subject.import_task = import_task
        end
        it "should destroy import_task" do
          subject.destroy
          ImportTask.exists?( import_task.id).should be_false
        end
    end
    context "without any import_task" do
        before(:each) do
          subject.import_task = nil
        end
        it "should not raise exception" do
          subject.destroy
          subject.should be_destroyed
        end
    end
  end

  describe "#levels" do
    let(:import_task){ Factory( :import_task )}
    context "when validation is without import" do
      it "should not return levels 1 and 2" do
        subject.levels.include?(1).should be_false
        subject.levels.include?(2).should be_false
      end
      context "when parameter_set is defined" do
        before(:each) do
          subject.parameter_set = "dummy"
        end
        it "should return level 3" do
          subject.levels.include?(3).should be_true
        end
      end
      context "when parameter_set is not defined" do
        before(:each) do
          subject.parameter_set = nil
        end
        it "should not return level 3" do
          subject.levels.include?(3).should_not be_true
        end
      end
    end
    context "when validation is done with an import" do
      before(:each) do
        subject.import_task = import_task
      end
      it "should return levels 1 and 2" do
        subject.levels.include?(1).should be_true
        subject.levels.include?(2).should be_true
      end
      context "when parameter_set is defined" do
        before(:each) do
          subject.parameter_set = "dummy"
        end
        it "should return level 3" do
          subject.levels.include?(3).should be_true
        end
      end
      context "when parameter_set is not defined" do
        before(:each) do
          subject.parameter_set = nil
        end
        it "should not return level 3" do
          subject.levels.include?(3).should_not be_true
        end
      end
    end

  end

  describe "#chouette_command" do
    it "should be a Chouette::Command instance" do
      subject.send( :chouette_command).class.should == Chouette::Command
    end
    it "should have schema same as referential.slug" do
      subject.send( :chouette_command).schema.should == subject.referential.slug
    end
  end

  describe "#validate" do
    let(:compliance_check_task){ Factory(:compliance_check_task) }
    let(:chouette_command) { "dummy" }
    context "for failing validation" do
      before(:each) do
        chouette_command.stub!( :run!).and_raise( "dummy")
        compliance_check_task.stub!( :chouette_command => chouette_command)
      end
      it "should have status 'failed'" do
        compliance_check_task.validate
        compliance_check_task.status.should == "failed"
      end
    end
    context "for successful validation" do
      before(:each) do
        compliance_check_task.stub!( :chouette_command => mock( :run! => true ))
      end
      it "should have status 'completed'" do
        compliance_check_task.validate
        compliance_check_task.status.should == "completed"
      end
    end
  end

  describe "#validate" do
    let(:compliance_check_task){ Factory(:compliance_check_task) }
    let(:command_args){ "dummy" }
    before(:each) do
      compliance_check_task.stub!( :chouette_command => mock( :run! => true ))
      compliance_check_task.stub!( :chouette_command_args => command_args)
    end
    it "should call chouette_command.run! with :c => 'import', :id => id" do
      compliance_check_task.send( :chouette_command).should_receive( :run! ).with(  command_args)
      compliance_check_task.validate
    end
  end

  describe "#delayed_validate" do
    let( :import_task){ Factory.build(:import_task) }
    before(:each) do
      subject.stub!( :delay => mock( :validate => true))
    end
    it "should not call delay#validate if import_task defined" do
      subject.import_task = import_task
      subject.delay.should_not_receive( :validate)
      subject.delayed_validate
    end
    it "should call delay#validate if import_task blank" do
      subject.import_task = nil
      subject.delay.should_receive( :validate)
      subject.delayed_validate
    end

  end

  describe "#define_default_attributes" do
    it "should keep status if defined" do
      subject.status = "dummy"
      subject.define_default_attributes
      subject.status.should == "dummy"
    end
    it "should set status to pending if not defined" do
      subject.status = nil
      subject.define_default_attributes
      subject.status.should == "pending"
    end
    context "when rule_parameter_set is nil" do
      before(:each) do
        subject.stub!( :rule_parameter_set => nil)
        subject.parameter_set = "dummy"
        subject.parameter_set_name = "dummy"
      end
      it "should keep parameter_set_name" do
        subject.define_default_attributes
        subject.parameter_set_name.should == "dummy"
      end
      it "should keep parameter_set" do
        subject.define_default_attributes
        subject.parameter_set.should == "dummy"
      end
    end
    context "when rule_parameter_set is defined" do
      let( :rule_parameter_set ){ Factory( :rule_parameter_set ) }
      before(:each) do
        subject.stub!( :rule_parameter_set => rule_parameter_set)
        subject.parameter_set = "dummy"
        subject.parameter_set_name = "dummy"
      end
      it "should set parameter_set_name to rule_parameter_set.name" do
        subject.define_default_attributes
        subject.parameter_set_name.should == rule_parameter_set.name
      end
      it "should keep set parameter_set to rule_parameter_set.parameters" do
        subject.define_default_attributes
        subject.parameter_set.should == rule_parameter_set.parameters
      end
    end
  end

  describe "#rule_parameter_set" do
    context "when rule_parameter_set_id is blank" do
      before(:each) do
        subject.rule_parameter_set_id = ""
      end
      it "should return nil" do
        subject.rule_parameter_set.should be_nil
      end
    end
    context "when rule_parameter_set_id is not blank" do
      let( :rule_parameter_set ){ Factory( :rule_parameter_set ) }
      before(:each) do
        subject.rule_parameter_set_id = rule_parameter_set.id
      end
      it "should return rule_parameter_set instance" do
        subject.rule_parameter_set.should == rule_parameter_set
      end
    end
  end

  describe "#rule_parameter_set_archived" do
    context "when parameter_set is blank" do
      before(:each) do
        subject.parameter_set = nil
      end
      it "should return nil" do
        subject.rule_parameter_set_archived.should be_nil
      end
    end
    context "when parameter_set is blank" do
      before(:each) do
        subject.parameter_set = { :speed => 30, :distance => 5 }
      end
      it "should return RuleParameterSet#parameters same as parameter_set" do
        subject.rule_parameter_set_archived.parameters.should == subject.parameter_set
      end
      it "should return RuleParameterSet#name same as parameter_set_name" do
        subject.rule_parameter_set_archived.name.should == subject.parameter_set_name
      end
    end

  end

#  describe "#validate" do
#
#    before(:each) do
#      subject.stub :validator => mock(:validate => true)
#    end
#
#    it "should create a ComplianceCheckResult :started when started" do
#      subject.validate
#      subject.compliance_check_results.first.should be_log_message(:key => "started")
#    end
#
#    it "should create a ComplianceCheckResult :completed when completed" do
#      subject.validate
#      subject.compliance_check_results.last.should be_log_message(:key => "completed")
#    end
#
#    it "should create a ComplianceCheckResult :failed when failed" do
#      pending
#      # subject.loader.stub(:export).and_raise("export failed")
#      subject.validate
#      subject.compliance_check_results.last.should be_log_message(:key => "failed")
#    end
#
#  end

  describe ".create" do
    let( :new_compliance_check_task){ Factory.build( :compliance_check_task) }

    it "should call #define_default_attributes" do
      new_compliance_check_task.should_receive( :define_default_attributes)
      new_compliance_check_task.save
    end

    it "should call #delayed_validate" do
      new_compliance_check_task.should_not_receive( :delayed_validate)
      new_compliance_check_task.save
    end

  end

  it_behaves_like TypeIdsModelable do
    let(:type_ids_model) { subject}
  end

end

