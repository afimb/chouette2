require 'spec_helper'

describe VehicleJourneysController, :type => :routing do
  describe "routing" do
    it "routes to #select_journey_pattern" do
      expect(get( "/referentials/1/lines/2/routes/3/vehicle_journeys/4/select_journey_pattern" )).to route_to(
        "vehicle_journeys#select_journey_pattern",
        "referential_id"=>"1", "line_id"=>"2", "route_id"=>"3", "id"=>"4"
      )
    end
  end
end

