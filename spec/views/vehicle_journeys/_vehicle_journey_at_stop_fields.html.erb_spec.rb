require 'spec_helper'

describe "/vehicle_journeys/_vehicle_journey_at_stop_fields", :type => :view do
  
  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:vehicle_journey) { assign :vehicle_journey, create(:vehicle_journey, :route => route) }
  let!(:vehicle_journey_at_stop) { assign :vehicle_journey_at_stop, vehicle_journey.vehicle_journey_at_stops.first }
  let!(:vehicle_journey_at_stop_counter) { assign :vehicle_journey_at_stop_counter, 0 }

  def render_collection
    render( :partial => "vehicle_journeys/vehicle_journey_at_stop_fields", :collection => vehicle_journey.vehicle_journey_at_stops, :as => :vehicle_journey_at_stop, :locals => { :vehicle_journey_at_stops_size => 1 } )
  end
 
  it "should render vehicle_journey_at_stop's departure time" do
    expect(rendered).to have_selector("td select[name='vehicle_journey[vehicle_journey_at_stops_attributes[0][departure_time(5i)]]']")
  end

  it "should render vehicle_journey_at_stop's stop_point_id" do
    render_collection
    puts rendered.inspect
    expect(rendered).to have_field("vehicle_journey[vehicle_journey_at_stops_attributes][0][stop_point_id]")
    expect(rendered).to have_field("vehicle_journey[vehicle_journey_at_stops_attributes][0][stop_point_id]",
                                      :with => vehicle_journey_at_stop.stop_point_id,
                                      :type => "hidden")
  end
  
  it "should render vehicle_journey_at_stop's id" do
    render_collection
    expect(rendered).to have_field("vehicle_journey[vehicle_journey_at_stops_attributes][0][id]",
                                   :with => vehicle_journey_at_stop.id,
                                   :type => "hidden")
  end
  
  it "should render vehicle_journey_at_stop's _destroy" do
    render_collection
    expect(rendered).to have_field("vehicle_journey[vehicle_journey_at_stops_attributes][0][_destroy]",
                                   :with => (vehicle_journey_at_stop._destroy ? "1" : "0"),
                                   :type => "hidden" )
  end
  
  it "should render vehicle_journey_at_stop's stop name" do
    render_collection
    expect(rendered).to have_selector("td label", :text => vehicle_journey_at_stop.stop_point.stop_area.name )
  end
  
  context "for a destroyed vehicle_journey_at_stop" do
    before(:each) do
      allow(vehicle_journey_at_stop).to receive_messages(:_destroy => true)
    end
    it "should render tr.no_stop" do
      pending
      render_collection
      expect(rendered).to have_selector("tr.no_stop")
    end
  end
  
  context "for a not destroyed vehicle_journey_at_stop" do
    before(:each) do
      allow(vehicle_journey_at_stop).to receive_messages(:_destroy => false)
    end
    it "should not render tr.no_stop" do
      render_collection
      expect(rendered).not_to have_selector("tr.no_stop")
    end
  end
end
