require 'spec_helper'

describe "/stop_areas/index", :type => :view do

  assign_user
  assign_referential
  let!(:stop_areas) { assign :stop_areas, Kaminari.paginate_array(Array.new(2) { create(:stop_area) }).page(1) }
  let!(:q) { assign :q, Ransack::Search.new(Chouette::StopArea) }

  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive(:link_with_search).and_return("#")
  end

  it "should render a show link for each group" do
    render
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector(".stop_area a[href='#{view.referential_stop_area_path(referential, stop_area)}']", :text => stop_area.name)
    end
  end

  it "should render a link to create a new group" do
    pending "NRP: deleted in setup"
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_stop_area_path(referential)}']")
  end

end
