require 'spec_helper'

describe Chouette::VehicleJourney, :type => :model do
  subject { create(:vehicle_journey_odd) }

  describe "in_relation_to_a_journey_pattern methods" do
    let!(:route) { create(:route)}
    let!(:journey_pattern) { create(:journey_pattern, :route => route)}
    let!(:journey_pattern_odd) { create(:journey_pattern_odd, :route => route)}
    let!(:journey_pattern_even) { create(:journey_pattern_even, :route => route)}

    context "when vehicle_journey is on odd stop whereas selected journey_pattern is on all stops" do
      subject { create(:vehicle_journey, :route => route, :journey_pattern => journey_pattern_odd)}
      describe "#extra_stops_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          expect(subject.extra_stops_in_relation_to_a_journey_pattern( journey_pattern)).to be_empty
        end
      end
      describe "#extra_vjas_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          expect(subject.extra_vjas_in_relation_to_a_journey_pattern( journey_pattern)).to be_empty
        end
      end
      describe "#missing_stops_in_relation_to_a_journey_pattern" do
        it "should return even stops" do
          result = subject.missing_stops_in_relation_to_a_journey_pattern( journey_pattern)
          expect(result).to eq(journey_pattern_even.stop_points)
        end
      end
      describe "#update_journey_pattern" do
        it "should new_record for added vjas" do
          subject.update_journey_pattern( journey_pattern)
          subject.vehicle_journey_at_stops.select{ |vjas| vjas.new_record? }.each do |vjas|
            expect(journey_pattern_even.stop_points).to include( vjas.stop_point)
          end
        end
        it "should add vjas on each even stops" do
          subject.update_journey_pattern( journey_pattern)
          vehicle_stops = subject.vehicle_journey_at_stops.map(&:stop_point)
          journey_pattern_even.stop_points.each do |sp|
            expect(vehicle_stops).to include(sp)
          end
        end
        it "should not mark any vjas as _destroy" do
          subject.update_journey_pattern( journey_pattern)
          expect(subject.vehicle_journey_at_stops.any?{ |vjas| vjas._destroy }).to be_falsey
        end
      end
    end
    context "when vehicle_journey is on all stops whereas selected journey_pattern is on odd stops" do
      subject { create(:vehicle_journey, :route => route, :journey_pattern => journey_pattern)}
      describe "#missing_stops_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          expect(subject.missing_stops_in_relation_to_a_journey_pattern( journey_pattern_odd)).to be_empty
        end
      end
      describe "#extra_stops_in_relation_to_a_journey_pattern" do
        it "should return even stops" do
          result = subject.extra_stops_in_relation_to_a_journey_pattern( journey_pattern_odd)
          expect(result).to eq(journey_pattern_even.stop_points)
        end
      end
      describe "#extra_vjas_in_relation_to_a_journey_pattern" do
        it "should return vjas on even stops" do
          result = subject.extra_vjas_in_relation_to_a_journey_pattern( journey_pattern_odd)
          expect(result.map(&:stop_point)).to eq(journey_pattern_even.stop_points)
        end
      end
      describe "#update_journey_pattern" do
        it "should add no new vjas" do
          subject.update_journey_pattern( journey_pattern_odd)
          expect(subject.vehicle_journey_at_stops.any?{ |vjas| vjas.new_record? }).to be_falsey
        end
        it "should mark vehicle_journey_at_stops as _destroy on even stops" do
          subject.update_journey_pattern( journey_pattern_odd)
          subject.vehicle_journey_at_stops.each { |vjas|
            expect(vjas._destroy).to eq(journey_pattern_even.stop_points.include?(vjas.stop_point))
          }
        end
      end
    end

  end
  context "when following departure times exceeds gap" do
    describe "#increasing_times" do
      before(:each) do
        subject.vehicle_journey_at_stops[0].departure_time = subject.vehicle_journey_at_stops[1].departure_time - 5.hour
        subject.vehicle_journey_at_stops[0].arrival_time = subject.vehicle_journey_at_stops[0].departure_time
        subject.vehicle_journey_at_stops[1].arrival_time = subject.vehicle_journey_at_stops[1].departure_time
      end
      it "should make instance invalid" do
        subject.increasing_times
        expect(subject.vehicle_journey_at_stops[1].errors[:departure_time]).not_to be_blank
        expect(subject).not_to be_valid
      end
    end
    describe "#update_attributes" do
      let!(:params){ {"vehicle_journey_at_stops_attributes" => {
            "0"=>{"id" => subject.vehicle_journey_at_stops[0].id ,"arrival_time" => 1.minutes.ago,"departure_time" => 1.minutes.ago},
            "1"=>{"id" => subject.vehicle_journey_at_stops[1].id, "arrival_time" => (1.minutes.ago + 4.hour),"departure_time" => (1.minutes.ago + 4.hour)}
         }}}
      it "should return false" do
        expect(subject.update_attributes(params)).to be_falsey
      end
      it "should make instance invalid" do
        subject.update_attributes(params)
        expect(subject).not_to be_valid
      end
      it "should let first vjas without any errors" do
        subject.update_attributes(params)
        expect(subject.vehicle_journey_at_stops[0].errors).to be_empty
      end
      it "should add an error on second vjas" do
        subject.update_attributes(params)
        expect(subject.vehicle_journey_at_stops[1].errors[:departure_time]).not_to be_blank
      end
    end
  end

  context "#time_table_tokens=" do
    let!(:tm1){create(:time_table, :comment => "TM1")}
    let!(:tm2){create(:time_table, :comment => "TM2")}

    it "should return associated time table ids" do
      subject.update_attributes :time_table_tokens => [tm1.id, tm2.id].join(',')
      expect(subject.time_tables).to include( tm1)
      expect(subject.time_tables).to include( tm2)
    end
  end
  describe "#bounding_dates" do
    before(:each) do
      tm1 = build(:time_table, :dates =>
                               [ build(:time_table_date, :date => 1.days.ago.to_date, :in_out => true),
                                 build(:time_table_date, :date => 2.days.ago.to_date, :in_out => true) ])
      tm2 = build(:time_table, :periods =>
                                [ build(:time_table_period, :period_start => 4.days.ago.to_date, :period_end => 3.days.ago.to_date)])
      tm3 = build(:time_table)
      subject.time_tables = [ tm1, tm2, tm3]
    end
    it "should return min date from associated calendars" do
      expect(subject.bounding_dates.min).to eq(4.days.ago.to_date)
    end
    it "should return max date from associated calendars" do
      expect(subject.bounding_dates.max).to eq(1.days.ago.to_date)
    end
  end
  context "#vehicle_journey_at_stops" do
    it "should be ordered like stop_points on route" do
      route = subject.route
      vj_stop_ids = subject.vehicle_journey_at_stops.map(&:stop_point_id)
      expected_order = route.stop_points.map(&:id).select {|s_id| vj_stop_ids.include?(s_id)}

      expect(vj_stop_ids).to eq(expected_order)
    end

  end

    describe "#transport_mode_name" do

    def self.legacy_transport_modes
      TransportMode.all_modes(:gtfs).map(&:first)
    end

    legacy_transport_modes.each do |transport_mode|
      context "when transport_mode is #{transport_mode}" do
        transport_mode_name = TransportMode.new(transport_mode)
        it "should be #{transport_mode_name}" do
          subject.transport_mode_name = transport_mode
          expect(subject.transport_mode_name).to eq(transport_mode_name.underscore)
        end
      end
    end
    context "when transport_mode is nil" do
      it "should be nil" do
        subject.transport_mode = nil
        expect(subject.transport_mode_name).to be_nil
      end
    end

  end

  describe "#transport_mode_name=" do

    it "should change transport_mode with TransportMode#name" do
      subject.transport_mode_name = "Test"
      expect(subject.transport_mode).to eq("Test")
    end

  end

  # describe ".transport_mode_names" do
  #
  #   it "should not include unknown transport_mode_name" do
  #     expect(Chouette::VehicleJourney.transport_mode_names).not_to include(Chouette::TransportModeDeprecated.new("unknown"))
  #   end
  #
  #   it "should not include interchange transport_mode" do
  #     expect(Chouette::VehicleJourney.transport_mode_names).not_to include(Chouette::TransportModeDeprecated.new("interchange"))
  #   end
  #
  # end

  describe "#footnote_ids=" do
    context "when line have footnotes, " do
      let!( :route) { create( :route ) }
      let!( :line) { route.line }
      let!( :footnote_first) {create( :footnote, :code => "1", :label => "dummy 1", :line => route.line)}
      let!( :footnote_second) {create( :footnote, :code => "2", :label => "dummy 2", :line => route.line)}


      it "should update vehicle's footnotes" do
        expect(Chouette::VehicleJourney.find(subject.id).footnotes).to be_empty
        subject.footnote_ids = [ footnote_first.id ]
        subject.save
        expect(Chouette::VehicleJourney.find(subject.id).footnotes.count).to eq(1)
      end

    end

  end

end

