require 'spec_helper'

describe "/routes/show", :type => :view do
  
  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  it "should render h2 with the route name" do
    render
    # NRP project changes
    expect(rendered).to have_selector("h2", :text => Regexp.new(route.name))
  end

  # it "should display a map with class 'line'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'line')
  # end

  it "should render a link to edit the route" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_line_route_path(referential, line, route)}']")
  end

  it "should render a link to remove the route" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_line_route_path(referential, line, route)}'][class='remove']")
  end

end

