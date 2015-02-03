require 'spec_helper'

describe "sdflkjskdjf" do

  subject { Factory(:line) }

  def set_large_object_id( line)
    line.update_attributes :objectid => "AA:Line:123456789012345"
  end

  describe "validation objectid unique constraint" do
    let(:organisation){subject.referential.organisation}
    let(:objectid_a){ "A:Line:1234" }
    let(:objectid_b){ "B:Line:1234" }
    let!(:second_line){ Factory( :line, :objectid => objectid_a, :registration_number => "123456") }
    context "when organisation works with HUB" do
      before( :each) do
        organisation.update_attributes :hub_restrictions => true
        subject.update_attributes :objectid => objectid_a
      end
      it "should have objectid with a third part shorter than 14 char" do
        subject.update_attributes :objectid => objectid_b
        subject.should_not be_valid
      end
    end
    context "when organisation doesn't works with HUB" do
      before( :each) do
        organisation.update_attributes :hub_restrictions => false
      end
      it "should have objectid with a third part shorter than 14 char" do
        subject.update_attributes :objectid => objectid_b
        subject.should be_valid
      end
    end
  end
  describe "validation objectid size" do
    let(:organisation){subject.referential.organisation}
    context "when organisation works with HUB" do
      before( :each) do
        organisation.update_attributes :hub_restrictions => true
      end
      it "should have objectid with a third part shorter than 14 char" do
        set_large_object_id( subject)
        subject.should_not be_valid
      end
    end
    context "when organisation doesn't works with HUB" do
      before( :each) do
        organisation.update_attributes :hub_restrictions => false
      end
      it "should have objectid with a third part shorter than 14 char" do
        set_large_object_id( subject)
        subject.should be_valid
      end
    end
  end
end

