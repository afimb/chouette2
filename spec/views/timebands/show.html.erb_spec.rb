require 'spec_helper'

describe "/timebands/show", :type => :view do

  assign_referential
  let!(:timeband) { assign(:timeband, create(:timeband)) }

  it "should render h2 with the timeband name" do
    render
    expect(rendered).to have_selector("h2", text: Regexp.new(timeband.name))
  end

  it "should render a link to edit the timeband" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_timeband_path(referential, timeband)}']")
  end

  it "should render a link to remove the timeband" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_timeband_path(referential, timeband)}'][class='remove']")
  end

end

