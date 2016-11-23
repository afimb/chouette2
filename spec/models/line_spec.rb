require 'spec_helper'

describe 'Line' do

  subject { create(:line) }

  def set_large_object_id( line)
    line.update_attributes :objectid => "123456789012345"
  end

  describe "validation objectid unique constraint" do
    let(:referential){subject.referential}
    let(:objectid_a){ "1234_1" }
    let(:objectid_b){ "1234_2" }
    let!(:second_line){ create( :line, :objectid => objectid_a, :registration_number => "123456") }
    context "when referential works with HUB" do
      before( :each) do
        referential.update_attributes :data_format => "hub"
        subject.update_attributes :objectid => objectid_a
      end
      it "should have objectid with a third part shorter than 14 char" do
        subject.update_attributes :objectid => objectid_b
        subject.should_not be_valid
      end
    end
    context "when referential doesn't works with HUB" do
      before( :each) do
        referential.update_attributes :data_format => "hub"
      end
      #it "should have objectid with a third part shorter than 14 char" do
      #  subject.update_attributes :objectid => objectid_b, :registration_number => '324'
      #  subject.should be_valid
      #end
    end
  end
  describe "validation objectid size" do
    let(:referential){subject.referential}
    context "when referential works with HUB" do
      before( :each) do
        referential.update_attributes :data_format => "hub"
      end
      it "should have objectid with a third part shorter than 14 char" do
        set_large_object_id( subject)
        subject.should_not be_valid
      end
    end
    context "when referential doesn't works with HUB" do
      before( :each) do
        referential.update_attributes :data_format => "hub"
      end
      #it "should have objectid with a third part shorter than 14 char" do
      #  set_large_object_id( subject)
      #  subject.should be_valid
      #end
    end
  end
end

