require 'spec_helper'

describe "/routes/show" do
  
  let!(:referential) { assign :referential, create(:referential) }
  let!(:line) { assign :line, create(:line) }
  let!(:route) { assign :route, create(:route, :line => line) }
  let!(:stop_points) { assign :stop_points, Array.new(2) { create(:stop_point) }.paginate }
  let!(:map) { assign(:map, mock(:to_html => '<div id="map"/>')) }

  it "should render h2 with the route name" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(line.name))
  end

  # it "should display a map with class 'line'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'line')
  # end

  it "should render a link to edit the route" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.edit_referential_line_route_path(referential, line, route)}']")
  end

  it "should render a link to remove the route" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.referential_line_route_path(referential, line, route)}'][class='remove']")
  end

end

