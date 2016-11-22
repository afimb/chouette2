require 'spec_helper'

describe Chouette::AccessLink, :type => :model do
  subject { create(:access_link) }

  it { is_expected.to validate_uniqueness_of :objectid }

  # TODO
  # describe '#objectid' do
  #   subject { super().objectid }
  #   it { is_expected.to be_kind_of(Chouette::ObjectId) }
  # end

  it { is_expected.to validate_presence_of :name }
  #it { is_expected.to validate_presence_of :link_type }
  it { is_expected.to validate_presence_of :link_orientation }

  describe "#access_link_type" do

    def self.legacy_link_types
      %w{Underground Mixed Overground}
    end

    legacy_link_types.each do |link_type|
      context "when link_type is #{link_type}" do
        access_link_type = Chouette::ConnectionLinkType.new(link_type.underscore)
        it "should be #{access_link_type}" do
          subject.link_type = link_type
          expect(subject.access_link_type).to eq(access_link_type)
        end
      end
    end
  end

  describe "#access_link_type=" do

    it "should change link_type with ConnectionLinkType#name" do
      subject.access_link_type = "underground"
      expect(subject.link_type).to eq("Underground")
    end

  end

  describe "#link_orientation_type" do

    def self.legacy_link_orientations
      %w{AccessPointToStopArea StopAreaToAccessPoint}
    end

    legacy_link_orientations.each do |link_orientation|
      context "when link_orientation is #{link_orientation}" do
        link_orientation_type = Chouette::LinkOrientationType.new(link_orientation.underscore)
        it "should be #{link_orientation_type}" do
          subject.link_orientation = link_orientation
          expect(subject.link_orientation_type).to eq(link_orientation_type)
        end
      end
    end

  end

  describe "#link_orientation_type=" do

    it "should change link_orientation with LinkOrientationType#name" do
      subject.link_orientation_type = "access_point_to_stop_area"
      expect(subject.link_orientation).to eq("AccessPointToStopArea")
    end

  end

  describe "#link_key" do
    it "should calculate link_key for access to area" do
      subject.link_orientation_type = "access_point_to_stop_area"
      expect(subject.link_key).to eq("A_#{subject.access_point.id}-S_#{subject.stop_area.id}")
    end
    it "should calculate link_key for area to access" do
      subject.link_orientation_type = "stop_area_to_access_point"
      expect(subject.link_key).to eq("S_#{subject.stop_area.id}-A_#{subject.access_point.id}")
    end

  end

end
