require 'spec_helper'

describe "/vehicle_journeys/_form" do
  
  let!(:referential) { assign :referential, create(:referential) }
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:vehicle_journey) { assign :vehicle_journey, create(:vehicle_journey, :route => route) }

  it "should render an input for transport_mode" do
    render
    rendered.should have_selector( "select", :name => "vehicle_journey[transport_mode]") do |node|
      Chouette::Line.transport_modes.each do |mode|
        node.should have_selector("option", :value => mode.text_code)
      end
    end
  end

  it "should render an input for comment" do
    render
    rendered.should have_selector("form") do 
      with_selector "input[type=text][comment=]", vehicle_journey.comment
    end
  end
  context "stop's time view part" do
    it "should render stop's names" do
      render
      rendered.should have_selector("form") do |form_node| 
        vehicle_journey.stop_points.each do |sp|
          form_node.with_selector "label", :text => sp.stop_area.name
        end
      end
    end
    it "renders _vehicle_journey_at_stop_fields partial for each vehicle_journey_at_stop" do
      render
      view.should render_template(:partial => "_vehicle_journey_at_stop_fields", :count => vehicle_journey.vehicle_journey_at_stops.count)
    end
    
    it "should render vehicle_journey_at_stop's departure time" do
      render
      rendered.should have_selector("form") do |form_node| 
        vehicle_journey.stop_points.each_with_index do |sp, index|
          form_node.with_selector "select", :name => "vehicle_journey[vehicle_journey_at_stops_attributes][#{index}][departure_time(4i)]"
          form_node.with_selector "select", :name => "vehicle_journey[vehicle_journey_at_stops_attributes][#{index}][departure_time(5i)]"
        end
      end
    end
  end
  context "when existing vehicle_journey" do
    it "should display objectid not as an input" do
      render
      rendered.should have_selector("form") do 
        with_selector "input[type=text][objectid=][disabled=true]", vehicle_journey.objectid
      end
    end
  end
  context "when new vehicle_journey" do
    let!(:vehicle_journey) { assign :vehicle_journey, build(:vehicle_journey, :route => route) }
    it "should render an input for objectid" do
      render
      rendered.should have_selector("form") do 
        with_selector "input[type=text][objectid=][disabled=false]", vehicle_journey.objectid
      end
    end
  end

end

