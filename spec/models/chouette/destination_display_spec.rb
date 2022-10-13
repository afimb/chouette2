require 'spec_helper'

describe Chouette::DestinationDisplay do

  subject { build(:destination_display) }
  let!(:destination_display) { create(:destination_display, :name => "Tromsø", :front_text => "Tromsø", :side_text => nil) }
  let!(:destination_display1) { create(:destination_display, :name => "Majorstuen", :front_text => "Majorstuen", :side_text => nil) }
  let!(:destination_display2) { create(:destination_display, :name => "Lillehammer", :front_text => "Lillehammer", :side_text => nil) }
  let!(:destination_display3) { create(:destination_display, :name => "Mit navn", :front_text => "Lillestrøm", :side_text => nil) }
  let!(:destination_display4) { create(:destination_display, :name => "Mo i Rana", :front_text => "Mo i Rana", :side_text => nil) }

  it { is_expected.to validate_presence_of :front_text }

  it { is_expected.to validate_presence_of :front_text }

  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.name = nil
      subject.side_text = nil
      expect(subject.name).to be_nil
      expect(subject.side_text).to be_nil
      expect(subject.objectid).not_to be_nil
    end
  end

  describe "#nullables empty vias" do
    it "should set null empty nullable attributes" do
      destination_display.vias = []
      expect(destination_display.vias.length).to eq 0
    end
  end

  describe "!nullables empty vias" do
    it "should raise error on nullable attributes" do
      expect{create(:destination_display, :front_text => nil)}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end


  describe "Destination Display Vias set self" do
    it "should raise" do
      expect{destination_display.vias = [destination_display]}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
