require 'spec_helper'

describe "/timebands/index", :type => :view do

  assign_referential
  let!(:timebands) { assign :timebands, Array.new(2){ create(:timeband) }.paginate }

  it "should render a show link for each timeband" do
    render
    timebands.each do |timeband|
      expect(rendered).to have_selector("a[href='#{view.referential_timeband_path(referential, timeband)}']", :text => timeband.name)
    end
  end

  it "should render a link to create a new timeband" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_timeband_path(referential)}']")
  end

end
