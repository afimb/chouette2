require 'spec_helper'

describe VehicleTranslation, :type => :model do
  let!(:company){ Factory(:company )}
  let!(:journey_pattern){Factory(:journey_pattern)}
  let!(:vehicle_journey){ Factory(:vehicle_journey,
                                  :objectid => "dummy",
                                  :journey_pattern => journey_pattern,
                                  :route => journey_pattern.route,
                                  :company => company,
                                  :transport_mode => Chouette::TransportMode.new("metro"),
                                  :published_journey_name => "dummy"
                                  )}
  subject {Factory.build(:vehicle_translation,
                         :vehicle_journey_id => vehicle_journey.id,
                         :first_stop_time => "12:00",
                         :departure_or_arrival => "departure",
                         :duration => 9,
                         :count => 2)}

  describe "#first_stop_time=" do
    context "when setting invalid value" do
      it "should have an error on first_stop_departure_time" do
        subject.first_stop_time = "dummy"
        subject.valid?
        expect(subject.errors[ :first_stop_time]).not_to be_nil
      end
    end

  end
  describe "#evaluate_delta" do
    it "should return 3600 seconds" do
      expect(subject.evaluate_delta( Time.parse( "11:00"))).to eq(3600.0)
    end
  end
  describe "#first_delta" do
    it "should return 3600 seconds" do
      expect(subject).to receive( :first_vjas_time).and_return( Time.parse( "11:00"))
      subject.first_delta
    end
  end

  describe "#translate" do
    it "should add new vehicle" do
      count_before = Chouette::VehicleJourney.count
      subject.translate
      count_after = Chouette::VehicleJourney.count
      expect(count_after).to eq(count_before + subject.count.to_i)
    end
    def last_created_vehicle
      Chouette::VehicleJourney.order( creation_time: :asc).last
    end
    it "should add vehicle having same published_journey_name" do
      subject.translate
      expect(last_created_vehicle.published_journey_name).to eq(vehicle_journey.published_journey_name)
    end
    it "should add vehicle having same transport_mode" do
      subject.translate
      expect(last_created_vehicle.transport_mode).to eq(vehicle_journey.transport_mode)
    end
    it "should add vehicle having same journey_pattern" do
      subject.translate
      expect(last_created_vehicle.journey_pattern).to eq(vehicle_journey.journey_pattern)
    end
    it "should add vehicle having same route" do
      subject.translate
      expect(last_created_vehicle.route).to eq(vehicle_journey.route)
    end
    it "should add vehicle having same company" do
      subject.translate
      expect(last_created_vehicle.company).to eq(vehicle_journey.company)
    end
    it "should add vehicle with as many vehicle_journey_at_stops as on basic vehicle" do
      subject.translate
      expect(last_created_vehicle.vehicle_journey_at_stops.count).to eq(vehicle_journey.vehicle_journey_at_stops.count)
    end
    it "should add vehicle where vehicle_journey_at_stops are translated with #duration" do
      read_vehicle = Chouette::VehicleJourney.find(vehicle_journey.id)  # read from bd, change time values
      delta = subject.first_delta
      subject.translate

      last_created_vehicle.vehicle_journey_at_stops.each_with_index do |vjas, index|
        expect(vjas.departure_time).to eq(read_vehicle.vehicle_journey_at_stops[index].departure_time + delta + subject.duration.minutes)
        expect(vjas.arrival_time).to eq(read_vehicle.vehicle_journey_at_stops[index].arrival_time + delta + subject.duration.minutes)
      end
    end
  end
end

