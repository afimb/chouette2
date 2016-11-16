require 'spec_helper'

describe Chouette::StopArea, :type => :model do
  let!(:quay) { create :stop_area, :area_type => "Quay" }
  let!(:boarding_position) { create :stop_area, :area_type => "BoardingPosition" }
  let!(:commercial_stop_point) { create :stop_area, :area_type => "CommercialStopPoint" }
  let!(:stop_place) { create :stop_area, :area_type => "StopPlace" }

  describe '#objectid' do
    subject { super().objectid }
    it { is_expected.to be_kind_of(Chouette::ObjectId) }
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :area_type }
  it { is_expected.to validate_numericality_of :latitude }
  it { is_expected.to validate_numericality_of :longitude }

  
  describe ".latitude" do
    it "should accept -90 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.latitude = -90
      expect(subject.valid?).to be_truthy
    end
    it "should reject < -90 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.latitude = -90.0001
      expect(subject.valid?).to be_falsey
    end
    it "should accept 90 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.latitude = 90
      expect(subject.valid?).to be_truthy
    end
    it "should reject > 90 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.latitude = 90.0001
      expect(subject.valid?).to be_falsey
    end
  end

  describe ".longitude" do
    it "should accept -180 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = -180
      expect(subject.valid?).to be_truthy
    end
    it "should reject < -180 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = -180.0001
      expect(subject.valid?).to be_falsey
    end
    it "should accept 180 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = 180
      expect(subject.valid?).to be_truthy
    end
    it "should reject > 180 value" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = 180.0001
      expect(subject.valid?).to be_falsey
    end
  end

  describe ".long_lat" do
    it "should accept longitude and latitude both as nil" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = nil
      subject.latitude = nil
      expect(subject.valid?).to be_truthy
    end
    it "should accept longitude and latitude both numerical" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = 10
      subject.latitude = 10
      expect(subject.valid?).to be_truthy
    end
    it "should reject longitude nil with latitude numerical" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = nil
      subject.latitude = 10
      expect(subject.valid?).to be_falsey
    end
    it "should reject longitude numerical with latitude nil" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      subject.longitude = 10
      subject.latitude = nil
      expect(subject.valid?).to be_falsey
    end
  end 
  

  describe ".children_in_depth" do
    it "should return all the deepest children from stop area" do
      subject = create :stop_area, :area_type => "StopPlace"
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint", :parent => subject 
      commercial_stop_point2 = create :stop_area, :area_type => "CommercialStopPoint", :parent => commercial_stop_point
      quay = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      expect(subject.children_in_depth).to match_array([commercial_stop_point, commercial_stop_point2, quay])
    end
    it "should return only the deepest children from stop area" do
      subject = create :stop_area, :area_type => "StopPlace"
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint", :parent => subject 
      commercial_stop_point2 = create :stop_area, :area_type => "CommercialStopPoint", :parent => commercial_stop_point
      quay = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      expect(subject.children_at_base).to match_array([quay])
    end
  end

  describe ".stop_area_type" do
    it "should have area_type of BoardingPosition when stop_area_type is set to boarding_position" do
      subject = create :stop_area, :stop_area_type => "boarding_position"
      expect(subject.area_type).to eq("BoardingPosition")
    end
    it "should have area_type of Quay when stop_area_type is set to quay" do
      subject = create :stop_area, :stop_area_type => "quay"
      expect(subject.area_type).to eq("Quay")
    end
    it "should have area_type of CommercialStopPoint when stop_area_type is set to commercial_stop_point" do
      subject = create :stop_area, :stop_area_type => "commercial_stop_point"
      expect(subject.area_type).to eq("CommercialStopPoint")
    end
    it "should have area_type of StopPlace when stop_area_type is set to stop_place" do
      subject = create :stop_area, :stop_area_type => "stop_place"
      expect(subject.area_type).to eq("StopPlace")
    end
  end

  describe ".parent" do
    it "should check if parent method exists" do
      subject = create :stop_area, :parent_id => commercial_stop_point.id
      expect(subject.parent).to eq(commercial_stop_point)
    end
  end

  describe ".possible_children" do    
    
    it "should find no possible descendant for stop area type quay" do
      subject = create :stop_area, :area_type => "Quay"
      expect(subject.possible_children).to eq([]) 
    end

    it "should find no possible descendant for stop area type boarding position" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      expect(subject.possible_children).to eq([]) 
    end

    it "should find descendant of type quay or boarding position for stop area type commercial stop point" do
      subject = create :stop_area, :area_type => "CommercialStopPoint"
      expect(subject.possible_children).to match_array([quay, boarding_position]) 
    end

    it "should find no children of type stop place or commercial stop point for stop area type stop place" do
      subject = create :stop_area, :area_type => "StopPlace"
      expect(subject.possible_children).to match_array([stop_place, commercial_stop_point]) 
    end

  end

  describe ".possible_parents" do

    it "should find parent type commercial stop point for stop area type boarding position" do
      subject = create :stop_area, :area_type => "BoardingPosition"
      expect(subject.possible_parents).to eq([commercial_stop_point]) 
    end

    it "should find parent type commercial stop point for stop area type quay" do
      subject = create :stop_area, :area_type => "Quay"
      expect(subject.possible_parents).to eq([commercial_stop_point]) 
    end    

    it "should find parent type stop place for stop area type commercial stop point" do
      subject = create :stop_area, :area_type => "CommercialStopPoint"
      expect(subject.possible_parents).to eq([stop_place]) 
    end    

    it "should find parent type stop place for stop area type stop place" do
      subject = create :stop_area, :area_type => "StopPlace"
      expect(subject.possible_parents).to eq([stop_place]) 
    end    

  end


  describe ".near" do

    let(:stop_area) { create :stop_area, :latitude => 1, :longitude => 1 }
    let(:stop_area2) { create :stop_area, :latitude => 1, :longitude => 1 }
    
    it "should find a StopArea at 300m from given origin" do
      expect(Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.250, :units => :kms))).to eq([stop_area])
    end

    it "should not find a StopArea at more than 300m from given origin" do
      expect(Chouette::StopArea.near(stop_area2.to_lat_lng.endpoint(0, 0.350, :units => :kms))).to be_empty
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

  describe ".bounds" do
    
    it "should return transform coordinates in floats" do
      allow(Chouette::StopArea.connection).to receive_messages :select_rows => [["113.5292500000000000", "22.1127580000000000", "113.5819330000000000", "22.2157050000000000"]]
      expect(GeoRuby::SimpleFeatures::Envelope).to receive(:from_coordinates).with([[113.5292500000000000, 22.1127580000000000], [113.5819330000000000, 22.2157050000000000]])
      Chouette::StopArea.bounds
    end

  end

  describe "#default_position" do
    
    it "should return referential center point when StopArea.bounds is nil" do
      allow(Chouette::StopArea).to receive_messages :bounds => nil
      expect(subject.default_position).not_to be_nil
    end

    it "should return StopArea.bounds center" do
      allow(Chouette::StopArea).to receive_messages :bounds => double(:center => "center")
      expect(subject.default_position).to eq(Chouette::StopArea.bounds.center)
    end

  end

  describe "#children_at_base" do
    it "should have 2 children_at_base" do
      subject = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => subject
      quay1 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      quay2 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      expect(subject.children_at_base.size).to eq(2)
    end
   end 


  describe "#generic_access_link_matrix" do
    it "should have no access_links in matrix with no access_point" do
      subject = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => subject
      expect(subject.generic_access_link_matrix.size).to eq(0)
    end
    it "should have 4 generic_access_links in matrix with 2 access_points" do
      subject = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => subject
      access_point1 = create :access_point, :stop_area => subject
      access_point2 = create :access_point, :stop_area => subject
      expect(subject.generic_access_link_matrix.size).to eq(4)
    end
   end 
  describe "#detail_access_link_matrix" do
    it "should have no access_links in matrix with no access_point" do
      subject = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => subject
      quay1 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      quay2 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      expect(subject.detail_access_link_matrix.size).to eq(0)
    end
    it "should have 8 detail_access_links in matrix with 2 children_at_base and 2 access_points" do
      subject = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => subject
      quay1 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      quay2 = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      access_point1 = create :access_point, :stop_area => subject
      access_point2 = create :access_point, :stop_area => subject
      expect(subject.detail_access_link_matrix.size).to eq(8)
    end
   end 
  describe "#parents" do
    it "should return parent hireachy list" do
      stop_place = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      subject = create :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      expect(subject.parents.size).to eq(2)
    end
    it "should return empty parent hireachy list" do
      subject = create :stop_area, :area_type => "Quay"
      expect(subject.parents.size).to eq(0)
    end
  end
  
  describe "#clean_invalid_access_links" do
    it "should remove invalid access links" do
      # subject is a CSP with a SP as parent, a quay as child
      # 2 access_points of SP have access_link, one on subject, one on subject child
      # when detaching subject from SP, both access_links must be deleted
      stop_place = create :stop_area, :area_type => "StopPlace" 
      subject = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      access_point1 = create :access_point, :stop_area => stop_place
      access_point2 = create :access_point, :stop_area => stop_place
      quay = create :stop_area, :parent => subject, :area_type => "Quay"
      access_link1 = create :access_link, :stop_area => subject, :access_point => access_point1
      access_link2 = create :access_link, :stop_area => quay, :access_point => access_point2
      subject.save 
      expect(subject.access_links.size).to eq(1)
      expect(quay.access_links.size).to eq(1)
      subject.parent=nil
      subject.save 
      subject.reload
      expect(subject.access_links.size).to eq(0)
      expect(quay.access_links.size).to eq(0)
    end
    it "should not remove still valid access links" do
      # subject is a Q of CSP with a SP as parent
      # 2 access_points, one of SP, one of CSP have access_link on subject
      # when changing subject CSP to another CSP of same SP
      # one access_links must be kept
      stop_place = create :stop_area, :area_type => "StopPlace" 
      commercial_stop_point1 = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      commercial_stop_point2 = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      access_point1 = create :access_point, :stop_area => stop_place
      access_point2 = create :access_point, :stop_area => commercial_stop_point1
      subject = create :stop_area, :parent => commercial_stop_point1, :area_type => "Quay"
      access_link1 = create :access_link, :stop_area => subject, :access_point => access_point1
      access_link2 = create :access_link, :stop_area => subject, :access_point => access_point2
      subject.save 
      expect(subject.access_links.size).to eq(2)
      subject.parent=commercial_stop_point2
      subject.save 
      subject.reload
      expect(subject.access_links.size).to eq(1)
    end
  end
  
  describe "#coordinates" do
    it "should convert coordinates into latitude/longitude" do
     subject = create :stop_area, :area_type => "BoardingPosition", :coordinates => "45.123,120.456"
     expect(subject.longitude).to be_within(0.001).of(120.456)
     expect(subject.latitude).to be_within(0.001).of(45.123)
   end
    it "should set empty coordinates into nil latitude/longitude" do
     subject = create :stop_area, :area_type => "BoardingPosition", :coordinates => "45.123,120.456"
     expect(subject.longitude).to be_within(0.001).of(120.456)
     expect(subject.latitude).to be_within(0.001).of(45.123)
     subject.coordinates = ""
     subject.save
     expect(subject.longitude).to be_nil
     expect(subject.latitude).to be_nil
   end
    it "should convert latitude/longitude into coordinates" do
     subject = create :stop_area, :area_type => "BoardingPosition", :longitude => 120.456, :latitude => 45.123
     expect(subject.coordinates).to eq("45.123,120.456")
   end
    it "should convert nil latitude/longitude into empty coordinates" do
     subject = create :stop_area, :area_type => "BoardingPosition", :longitude => nil, :latitude => nil
     expect(subject.coordinates).to eq("")
   end
    it "should accept valid coordinates" do
     subject = create :stop_area, :area_type => "BoardingPosition", :coordinates => "45.123,120.456"
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
     subject = create :stop_area, :area_type => "BoardingPosition", :coordinates => "90,180"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90,-180"
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90.,180."
     expect(subject.valid?).to be_truthy
     subject.coordinates = "-90.0,180.00"
     expect(subject.valid?).to be_truthy
    end
    it "should reject invalid coordinates" do
     subject = create :stop_area, :area_type => "BoardingPosition"
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

  describe "#duplicate" do
      it "should be a copy of" do
        stop_place = create :stop_area, :area_type => "StopPlace" 
        subject = create :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place, :coordinates => "45.123,120.456"
        access_point1 = create :access_point, :stop_area => subject
        access_point2 = create :access_point, :stop_area => subject
        quay1 = create :stop_area, :parent => subject, :area_type => "Quay"
        target=subject.duplicate
        expect(target.id).to be_nil
        expect(target.name).to eq(I18n.t("activerecord.copy", name: subject.name))
        expect(target.objectid).to eq(subject.objectid+"_1")
        expect(target.area_type).to eq(subject.area_type)
        expect(target.parent).to be_nil
        expect(target.children.size).to eq(0)
        expect(target.access_points.size).to eq(0)
        expect(target.coordinates).to eq("45.123,120.456")
      end
  end


end
