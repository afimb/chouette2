require 'spec_helper'

describe "/vehicle_journeys/edit" do
  
  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:vehicle_journey) { assign :vehicle_journey, create(:vehicle_journey, :route => route) }

  it "renders _form" do
    render
    view.should render_template(:partial => "_form")
  end
  context "summary part" do
    it "should render route name" do
      render
      rendered.should have_selector( ".summary a", :text => route.name)
    end
  end

end

