require 'spec_helper'

describe "/destination_displays/show", :type => :view do
  
  assign_referential
  let!(:destination_display) { assign(:destination_display, create(:destination_display)) }

  it "should render h2 with the destination_display name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(destination_display.name))
  end

  # it "should display a map with class 'destination_display'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'destination_display')
  # end

  it "should render a link to edit the destination_display" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_destination_display_path(referential, destination_display)}']")
  end

  it "should render a link to remove the destination_display" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_destination_display_path(referential, destination_display)}'][class='remove']")
  end

end

