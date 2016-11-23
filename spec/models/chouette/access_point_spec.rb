require 'spec_helper'

describe Chouette::AccessPoint, :type => :model do

  # describe '#objectid' do
  #   subject { super().objectid }
  #   it { is_expected.to be_kind_of(Chouette::ObjectId) }
  # end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_numericality_of :latitude }
  it { is_expected.to validate_numericality_of :longitude }

  describe ".latitude" do
    it "should accept -90 value" do
      subject = create :access_point
      subject.latitude = -90
      expect(subject.valid?).to be_truthy
    end
    it "should reject < -90 value" do
      subject = create :access_point
      subject.latitude = -90.0001
      expect(subject.valid?).to be_falsey
    end
    it "should accept 90 value" do
      subject = create :access_point
      subject.latitude = 90
      expect(subject.valid?).to be_truthy
    end
    it "should reject > 90 value" do
      subject = create :access_point
      subject.latitude = 90.0001
      expect(subject.valid?).to be_falsey
    end
  end

  describe ".longitude" do
    it "should accept -180 value" do
      subject = create :access_point
      subject.longitude = -180
      expect(subject.valid?).to be_truthy
    end
    it "should reject < -180 value" do
      subject = create :access_point
      subject.longitude = -180.0001
      expect(subject.valid?).to be_falsey
    end
    it "should accept 180 value" do
      subject = create :access_point
      subject.longitude = 180
      expect(subject.valid?).to be_truthy
    end
    it "should reject > 180 value" do
      subject = create :access_point
      subject.longitude = 180.0001
      expect(subject.valid?).to be_falsey
    end
  end

  describe ".long_lat" do
    it "should accept longitude and latitude both as nil" do
      subject = create :access_point
      subject.longitude = nil
      subject.latitude = nil
      expect(subject.valid?).to be_truthy
    end
    it "should accept longitude and latitude both numerical" do
      subject = create :access_point
      subject.longitude = 10
      subject.latitude = 10
      expect(subject.valid?).to be_truthy
    end
    it "should reject longitude nil with latitude numerical" do
      subject = create :access_point
      subject.longitude = nil
      subject.latitude = 10
      expect(subject.valid?).to be_falsey
    end
    it "should reject longitude numerical with latitude nil" do
      subject = create :access_point
      subject.longitude = 10
      subject.latitude = nil
      expect(subject.valid?).to be_falsey
    end
  end

  describe "#access_type" do
    def self.legacy_access_types
      %w{In Out InOut}
    end

    legacy_access_types.each do |access_type|
      context "when access_type is #{access_type}" do
        access_point_type = Chouette::AccessPointType.new(access_type.underscore)
        it "should be #{access_point_type}" do
          subject.access_type = access_type
          expect(subject.access_point_type).to eq(access_point_type)
        end
      end
    end
  end

  describe "#access_point_type=" do
    it "should change access_type with Chouette::AccessPointType#name" do
      subject.access_point_type = "in_out"
      expect(subject.access_type).to eq("InOut")
    end

  end

  describe "#to_lat_lng" do

    it "should return nil if latitude is nil" do
      subject.latitude = nil
      expect(subject.to_lat_lng).to be_nil
    end

    it "should return nil if longitude is nil" do
      subject.longitude = nil
      expect(subject.to_lat_lng).to be_nil
    end

  end

  describe "#geometry" do

    it "should be nil when to_lat_lng is nil" do
      allow(subject).to receive_messages :to_lat_lng => nil
      expect(subject.geometry).to be_nil
    end

  end

  describe "#generic_access_link_matrix" do
    it "should have 2 generic_access_links in matrix" do
      stop_place = create :stop_area, :area_type => "StopPlace"
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      subject = create :access_point, :stop_area => stop_place
      expect(subject.generic_access_link_matrix.size).to eq(2)
    end

    it "should have new generic_access_links in matrix" do
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
      subject = create :access_point, :stop_area => commercial_stop_point
      subject.generic_access_link_matrix.each do |link|
        expect(link.id).to be_nil
      end
    end
    it "should have only last generic_access_links as new in matrix" do
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
      subject = create :access_point, :stop_area => commercial_stop_point
      link = create :access_link, :access_point => subject, :stop_area => commercial_stop_point
      subject.generic_access_link_matrix.each do |link|
        if link.link_key.start_with?"A_"
          expect(link.id).not_to be_nil
        else
          expect(link.id).to be_nil
        end
      end
    end
  end

  describe "#detail_access_link_matrix" do
    it "should have 4 detail_access_links in matrix" do
      stop_place = create :stop_area, :area_type => "StopPlace"
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      quay1 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      quay2 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = create :access_point, :stop_area => stop_place
      expect(subject.detail_access_link_matrix.size).to eq(4)
    end

    it "should have new detail_access_links in matrix" do
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
      quay = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = create :access_point, :stop_area => commercial_stop_point
      subject.detail_access_link_matrix.each do |link|
        expect(link.id).to be_nil
      end
    end
    it "should have only last detail_access_links as new in matrix" do
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
      quay = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = create :access_point, :stop_area => commercial_stop_point
      link = create :access_link, :access_point => subject, :stop_area => quay
      subject.detail_access_link_matrix.each do |link|
        if link.link_key.start_with?"A_"
          expect(link.id).not_to be_nil
        else
          expect(link.id).to be_nil
        end
      end
    end
  end

  describe "#coordinates" do
    it "should convert coordinates into latitude/longitude" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     expect(subject.longitude).to be_within(0.001).of(120.456)
     expect(subject.latitude).to be_within(0.001).of(45.123)
   end
    it "should set empty coordinates into nil latitude/longitude" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     expect(subject.longitude).to be_within(0.001).of(120.456)
     expect(subject.latitude).to be_within(0.001).of(45.123)
     subject.coordinates = ""
     subject.save
     expect(subject.longitude).to be_nil
     expect(subject.latitude).to be_nil
   end
    it "should convert latitude/longitude into coordinates" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :longitude => 120.456, :latitude => 45.123
     expect(subject.coordinates).to eq("45.123,120.456")
   end
    it "should convert nil latitude/longitude into empty coordinates" do
    commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :longitude => nil, :latitude => nil
     expect(subject.coordinates).to eq("")
   end
    it "should accept valid coordinates" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "45.123, 120.456"
     expect(subject.valid?).to be_truthy
     expect(subject.longitude).to be_within(0.001).of(120.456)
     expect(subject.latitude).to be_within(0.001).of(45.123)
     subject.coordinates = "45.123,  -120.456"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "45.123 ,120.456"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "45.123   ,   120.456"
     expect(subject.valid?).to be_truthy
     subject.coordinates = " 45.123,120.456"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "45.123,120.456  "
     expect(subject.valid?).to be_truthy
    end
    it "should accept valid coordinates on limits" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point, :coordinates => "90,180"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90,-180"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90.,180."
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90.0,180.00"
     expect(subject.valid?).to be_truthy
    end
    it "should reject invalid coordinates" do
     commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint"
     subject = create :access_point, :stop_area => commercial_stop_point
     subject.coordinates = ",12"
     expect(subject.valid?).to be_falsey
     subject.coordinates = "-90"
     expect(subject.valid?).to be_falsey
     subject.coordinates = "-90.1,180."
     expect(subject.valid?).to be_falsey
     subject.coordinates = "-90.0,180.1"
     expect(subject.valid?).to be_falsey
     subject.coordinates = "-91.0,18.1"
     expect(subject.valid?).to be_falsey
    end
  end

end
