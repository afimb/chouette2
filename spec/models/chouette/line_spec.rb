require 'spec_helper'

describe Chouette::Line, :type => :model do

  subject { create(:line) }

  it { is_expected.to validate_presence_of :network }
  it { is_expected.to validate_presence_of :company }

  it { is_expected.to validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { is_expected.to validate_uniqueness_of :objectid }

  # describe '#objectid' do
  #   subject { super().objectid }
  #   it { is_expected.to be_kind_of(Chouette::ObjectId) }
  # end

  # it { should validate_numericality_of :objectversion }

  describe ".last_stop_areas_parents" do

    it "should return stop areas if no parents" do
      line = create(:line_with_stop_areas)
      expect(line.stop_areas_last_parents).to eq(line.stop_areas)
    end

    it "should return stop areas parents if parents" do
      line = create(:line_with_stop_areas)
      route = create(:route, :line => line)
      parent = create(:stop_area)
      stop_areas = [ create(:stop_area),  create(:stop_area), create(:stop_area, :parent_id => parent.id) ]
      stop_areas.each do |stop_area|
        create(:stop_point, :stop_area => stop_area, :route => route)
      end

      expect(line.stop_areas_last_parents).to match(line.stop_areas[0..(line.stop_areas.size - 2)].push(parent))
    end

  end

  describe "#stop_areas" do
    let!(:route){create(:route, :line => subject)}
    it "should retreive route's stop_areas" do
      expect(subject.stop_areas.count).to eq(route.stop_points.count)
    end
  end

  describe "#transport_mode" do

    def self.legacy_transport_mode_names
      TransportMode.all_modes(:gtfs).map(&:first)
    end

    legacy_transport_mode_names.each do |transport_mode_name|
      context "when transport_mode_name is #{transport_mode_name}" do
        transport_mode = TransportMode.new(transport_mode_name)
        it "should be #{transport_mode}" do
          subject.transport_mode_name = transport_mode_name
          expect(subject.transport_mode_name).to eq(transport_mode.to_s)
        end
      end
    end
    context "when transport_mode_name is nil" do
      it "should be nil" do
        subject.transport_mode_name = nil
        expect(subject.transport_mode_name).to be_nil
      end
    end

  end

  describe "#transport_mode_name=" do

    it "should change transport_mode_name with TransportMode#name" do
      subject.transport_mode_name = "Test"
      expect(subject.transport_mode_name).to eq("Test")
    end

  end

  # No more needed
  # describe ".transport_modes" do
  #
  #   it "should not include unknown transport_mode" do
  #     expect(Chouette::Line.transport_modes).not_to include(Chouette::TransportMode.new("unknown"))
  #   end
  #
  #   it "should not include interchange transport_mode" do
  #     expect(Chouette::Line.transport_modes).not_to include(Chouette::TransportMode.new("interchange"))
  #   end
  #
  # end

  context "#group_of_line_tokens=" do
    let!(:group_of_line1){create(:group_of_line)}
    let!(:group_of_line2){create(:group_of_line)}

    it "should return associated group_of_line ids" do
      subject.update_attributes :group_of_line_tokens => [group_of_line1.id, group_of_line2.id].join(',')
      expect(subject.group_of_lines).to include( group_of_line1)
      expect(subject.group_of_lines).to include( group_of_line2)
    end
  end

  describe "#update_attributes footnotes_attributes" do
    context "instanciate 2 footnotes without line" do
      let!( :footnote_first) {build( :footnote, :line_id => nil)}
      let!( :footnote_second) {build( :footnote, :line_id => nil)}
      it "should add 2 footnotes to the line" do
        subject.update_attributes :footnotes_attributes =>
          { Time.now.to_i => footnote_first.attributes,
            (Time.now.to_i-5) => footnote_second.attributes}
        expect(Chouette::Line.find( subject.id ).footnotes.size).to eq(2)
      end
    end
  end


end
