require 'spec_helper'

describe "/networks/show" do
  
  let!(:referential) { assign(:referential, Factory(:referential)) }
  let!(:network) { assign(:network, Factory(:network)) }
  let!(:map) { assign(:map, mock(:to_html => '<div id="map"/>')) }

  it "should render h2 with the network name" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(network.name))
  end

  it "should display a map with class 'network'" do
    render
    rendered.should have_selector("#map")
  end

  it "should render a link to edit the network" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.edit_referential_network_path(referential, network)}']")
  end

  it "should render a link to remove the network" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.referential_network_path(referential, network)}'][class='remove']")
  end

end

