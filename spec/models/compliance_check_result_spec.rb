require 'spec_helper'

describe ComplianceCheckResult do

  subject { Factory( :compliance_check_result)}

  describe "#indice" do
    context "when 1-NEPTUNE-XML-1 result" do
      before(:each) do
        subject.rule_code = "1-NEPTUNE-XML-1"
      end
      its(:indice) { should == 1 }
    end
    context "when 2-NETEX-AccessLink-2 result" do
      before(:each) do
        subject.rule_code = "2-NETEX-AccessLink-2"
      end
      its(:indice) { should == 2 }
    end
  end

  describe "#data_type" do
    context "when 1-NEPTUNE-XML-1 result" do
      before(:each) do
        subject.rule_code = "1-NEPTUNE-XML-1"
      end
      its(:data_type) { should == "XML" }
    end
    context "when 2-NETEX-AccessLink-2 result" do
      before(:each) do
        subject.rule_code = "2-NETEX-AccessLink-2"
      end
      its(:data_type) { should == "AccessLink" }
    end
  end

  describe "#format" do
    context "when 1-NEPTUNE-XML-1 result" do
      before(:each) do
        subject.rule_code = "1-NEPTUNE-XML-1"
      end
      its(:format) { should == "NEPTUNE" }
    end
    context "when 2-NETEX-AccessLink-2 result" do
      before(:each) do
        subject.rule_code = "2-NETEX-AccessLink-2"
      end
      its(:format) { should == "NETEX" }
    end
  end

  describe "#level" do
    context "when 1-NEPTUNE-XML-1 result" do
      before(:each) do
        subject.rule_code = "1-NEPTUNE-XML-1"
      end
      its(:level) { should == 1 }
    end
    context "when 2-NEPTUNE-AccessLink-2 result" do
      before(:each) do
        subject.rule_code = "2-NEPTUNE-AccessLink-2"
      end
      its(:level) { should == 2 }
    end
  end

end

