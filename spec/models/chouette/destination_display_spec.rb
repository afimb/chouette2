require 'spec_helper'

describe Chouette::DestinationDisplay do

  subject { build(:destination_display) }
  let!(:destination_display) { create(:destination_display, :name => "Tromsø", :front_text => "Tromsø", :side_text => nil) }
  let!(:destination_display1) { create(:destination_display, :name => "Majorstuen", :front_text => "Majorstuen", :side_text => nil) }
  let!(:destination_display2) { create(:destination_display, :name => "Lillehammer", :front_text => "Lillehammer", :side_text => nil) }
  let!(:destination_display4) { create(:destination_display, :name => "Mo i Rana", :front_text => "Mo i Rana", :side_text => nil) }
  let!(:destination_display5) { create(:destination_display, :name => "Skybar", :front_text => "Hemsedal", :side_text => nil, :vias => [destination_display1, destination_display2]) }

  it { should validate_presence_of :front_text }

  it { is_expected.to validate_presence_of :front_text }

  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.name = nil
      subject.side_text = nil
      subject.created_at = nil
      subject.updated_at = nil
      expect(subject.name).to be_nil
      expect(subject.side_text).to be_nil
      expect(subject.created_at).to be_nil
      expect(subject.updated_at).to be_nil
    end
  end

  describe "#nullables empty vias" do
    it "should set null empty nullable attributes" do
      destination_display.vias = []
      expect(destination_display.vias.length).to eq 0
    end
  end

  describe "Destination Display Vias" do
    it "should be able to set vias in create" do
      destination_display_n = create(:destination_display, :name => "Århus", :front_text => "Århus", :side_text => nil, :vias => [destination_display1])
      expect(destination_display_n.vias.length).to eq 1
      expect(destination_display_n.vias.first.name).to eq "Majorstuen"
      expect(destination_display_n.vias.first.front_text).to eq "Majorstuen"
      expect(destination_display_n.vias.first.side_text).to be_nil
      expect(destination_display_n.vias.first.vias.length).to eq 0

    end
  end


  describe "Destination Display Vias" do
    it "should be able to update vias" do
      expect(destination_display.vias.length).to eq 0
      destination_display.vias = [destination_display1, destination_display2]
      expect(destination_display.vias.length).to eq 2

      expect(destination_display.vias.first).to eq destination_display1
      expect(destination_display.vias.last).to eq destination_display2

    end
  end

  describe "Destination Display Vias" do
    it "should be able to delete vias" do
      expect(destination_display5.vias.length).to eq 2
      destination_display5.vias = []
      expect(destination_display5.vias.length).to eq 0
    end
  end


  describe "Destination Display Vias set self" do
    it "should raise" do
      expect{destination_display.vias = [destination_display]}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
