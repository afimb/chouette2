require 'spec_helper'

describe Chouette::DestinationDisplay do

  subject { build(:destination_display) }
  let!(:destination_display) { create(:destination_display, :name => "ABC", :front_text => "Bus to Majorstuen", :side_text => nil) }

  it { should validate_presence_of :front_text }

  it { is_expected.to validate_presence_of :front_text }

  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.name = nil
      subject.side_text = nil
      subject.created_at = ''
      subject.updated_at = ''
      expect(subject.name).to be_nil
      expect(subject.side_text).to be_nil
      expect(subject.created_at).to be_nil
      expect(subject.updated_at).to be_nil
    end
  end

  describe "#nullables empty 2" do
    it "should set null empty nullable attributes" do
      destination_display.name = 'ABC'
      destination_display.front_text = 'Bus text'
      destination_display.created_at = ''
      destination_display.updated_at = ''
      expect(destination_display.created_at).to be_nil
      expect(destination_display.updated_at).to be_nil
    end
  end
end
