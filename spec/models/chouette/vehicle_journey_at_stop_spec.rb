require 'spec_helper'
require 'pp'

describe Chouette::VehicleJourneyAtStop, :type => :model do
  let!(:vehicle_journey) { create(:vehicle_journey_odd)}
  subject { vehicle_journey.vehicle_journey_at_stops.first }

  describe "#exceeds_gap?" do
    it "should return false if gap < 1.hour" do
      t1 = 1.minutes.ago
      t2 = 1.minutes.ago + 4.hour
      expect(subject.exceeds_gap?(t1, t2)).to be_truthy
    end
    it "should return false if gap > 2.hour" do
      t1 = 1.minutes.ago
      t2 = 1.minutes.ago + 3.minutes
      expect(subject.exceeds_gap?(t1, t2)).to be_falsey
    end
  end

  describe "#increasing_times_validate" do
    let(:vjas1){ vehicle_journey.vehicle_journey_at_stops[0]}
    let(:vjas2){ vehicle_journey.vehicle_journey_at_stops[1]}
    context "when vjas#arrival_time exceeds gap" do
      it "should add errors on arrival_time" do
        vjas1.arrival_time = vjas2.arrival_time - 5.hour
        expect(vjas2.increasing_times_validate(vjas1)).to be_falsey
        expect(vjas2.errors).not_to be_empty
        expect(vjas2.errors[:arrival_time]).not_to be_blank
      end
    end
    context "when vjas#departure_time exceeds gap" do
      it "should add errors on departure_time" do
        vjas1.departure_time = vjas2.departure_time - 5.hour
        expect(vjas2.increasing_times_validate(vjas1)).to be_falsey
        expect(vjas2.errors).not_to be_empty
        expect(vjas2.errors[:departure_time]).not_to be_blank
      end
    end
    context "when vjas does'nt exceed gap" do
      it "should not add errors" do
        expect(vjas2.increasing_times_validate(vjas1)).to be_truthy
        expect(vjas2.errors).to be_empty
      end
    end
  end
end 
