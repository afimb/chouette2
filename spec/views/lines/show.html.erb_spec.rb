require 'spec_helper'

describe "/lines/show", :type => :view do

  assign_user
  assign_referential
  let!(:line) { assign :line, create(:line) }
  let!(:routes) { assign :routes, Kaminari.paginate_array(Array.new(2) { create(:route, :line => line) }) }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  it "should render h2 with the line name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(line.name))
  end

  # it "should display a map with class 'line'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'line')
  # end

  it "should render a link to edit the line" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_line_path(referential, line)}']")
  end

  it "should render a link to remove the line" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_line_path(referential, line)}'][class='remove']")
  end

end

