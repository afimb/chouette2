require 'spec_helper'

describe "/networks/show", :type => :view do
  
  assign_referential
  let!(:network) { assign(:network, create(:network)) }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  it "should render h2 with the network name" do
    render
    expect(rendered).to have_selector("#network_name", :text => Regexp.new(network.name))
  end

  it "should display a map with class 'network'" do
    render
    expect(rendered).to have_selector("#map")
  end

  it "should render a link to edit the network" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_network_path(referential, network)}']")
  end

  it "should render a link to remove the network" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_network_path(referential, network)}'][class='remove']")
  end

end

