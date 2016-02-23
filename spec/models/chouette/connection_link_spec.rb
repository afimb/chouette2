require 'spec_helper'

describe Chouette::ConnectionLink, :type => :model do
  let!(:quay) { create :stop_area, :area_type => "Quay" }
  let!(:boarding_position) { create :stop_area, :area_type => "BoardingPosition" }
  let!(:commercial_stop_point) { create :stop_area, :area_type => "CommercialStopPoint" }
  let!(:stop_place) { create :stop_area, :area_type => "StopPlace" }
  let!(:itl) { create :stop_area, :area_type => "ITL" }
  subject { create(:connection_link) }

  it { is_expected.to validate_uniqueness_of :objectid }

  describe '#objectid' do
    subject { super().objectid }
    it { is_expected.to be_kind_of(Chouette::ObjectId) }
  end

  it { is_expected.to validate_presence_of :name }

  describe "#connection_link_type" do

    def self.legacy_link_types
      %w{Underground Mixed Overground}
    end
    
    legacy_link_types.each do |link_type|
      context "when link_type is #{link_type}" do
        connection_link_type = Chouette::ConnectionLinkType.new(link_type.underscore)
        it "should be #{connection_link_type}" do
          subject.link_type = link_type
          expect(subject.connection_link_type).to eq(connection_link_type)
        end
      end
    end
    context "when link_type is nil" do
      it "should be nil" do
        subject.link_type = nil
        expect(subject.connection_link_type).to be_nil
      end
    end

  end

  describe "#connection_link_type=" do
    
    it "should change link_type with ConnectionLinkType#name" do
      subject.connection_link_type = "Test"
      expect(subject.link_type).to eq("Test")
    end

  end

  describe ".possible_areas" do

    it "should not find areas type ITL" do
      expect(subject.possible_areas).not_to eq([itl]) 
    end
  end

end
