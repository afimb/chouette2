require 'spec_helper'

describe "/vehicle_journeys/edit", :type => :view do
  
  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:vehicle_journey) { assign :vehicle_journey, create(:vehicle_journey, :route => route) }

  it "renders _form" do
    render
    expect(view).to render_template(:partial => "_form")
  end

end

