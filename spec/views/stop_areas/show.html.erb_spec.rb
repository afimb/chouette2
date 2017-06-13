require 'spec_helper'

describe "/stop_areas/show", :type => :view do
  
  assign_referential
  let!(:stop_area) { assign :stop_area, create(:stop_area) }
  let!(:access_points) { assign :access_points, [] }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  it "should render h2 with the stop_area name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(stop_area.name))
  end

  # it "should display a map with class 'stop_area'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'stop_area')
  # end

  it "should render a link to edit the stop_area" do
    pending "NRP: deleted in setup"
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_stop_area_path(referential, stop_area)}']")
  end

  it "should render a link to remove the stop_area" do
    pending "NRP: deleted in setup"
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_stop_area_path(referential, stop_area)}'][class='remove']")
  end

end

