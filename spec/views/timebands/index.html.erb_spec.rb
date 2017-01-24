require 'spec_helper'

describe "/timebands/index", :type => :view do

  assign_user
  assign_referential
  let!(:timebands) { assign :timebands, Kaminari.paginate_array(Array.new(2){ create(:timeband) }).page(1) }

  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

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
