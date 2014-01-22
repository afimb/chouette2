require 'spec_helper'

describe RuleParameterSet do

  describe ".mode_of_mode_attribute" do
    it "should retreive attribute name" do
      subject.class.attribute_of_mode_attribute("dummy1_mode_dummy2").should == "dummy1"
    end
    it "should retreive mode" do
      subject.class.mode_of_mode_attribute("dummy1_mode_dummy2").should == "dummy2"
    end
  end

  RuleParameterSet.mode_attribute_prefixes.each do |prefix|
    RuleParameterSet.all_modes.map do |mode|
      "#{prefix}_mode_#{mode}".tap do |attribute|
        describe "##{attribute}=" do
          it "should store value on parameters hash" do
            subject.send( "#{attribute}=".to_sym, 1234)
            subject.send( attribute.to_sym).should == 1234
            subject.parameters["mode_#{mode}"][ prefix].should == 1234
          end
        end
        it { should allow_mass_assignment_of attribute.to_sym}
      end
    end
  end

  RuleParameterSet.general_attributes.each do |attribute|
    describe "##{attribute}=" do
      it "should store value on parameters hash" do
        subject.send( "#{attribute}=".to_sym, 1234)
        subject.send( attribute.to_sym).should == 1234
        subject.parameters[ attribute].should == 1234
      end
    end
    it { should allow_mass_assignment_of attribute.to_sym}
  end

  describe "#referential" do
    it { should validate_presence_of(:referential) }
    it { should allow_mass_assignment_of :referential_id }
  end

  describe "#name" do
    it { should validate_presence_of(:name) }
    it { should allow_mass_assignment_of :name }
  end
end
