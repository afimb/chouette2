require 'spec_helper'

describe "/stop_areas/index" do

  assign_referential
  let!(:stop_areas) { assign :stop_areas, Array.new(2) { create(:stop_area) }.paginate }  
  let!(:q) { assign :q, Ransack::Search.new(Chouette::StopArea) }

  before :each do
    view.stub(:link_with_search).and_return("#")
  end

  it "should render a show link for each group" do        
    render  
    stop_areas.each do |stop_area|      
      rendered.should have_selector(".stop_area a[href='#{view.referential_stop_area_path(referential, stop_area)}']", :text => stop_area.name)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_stop_area_path(referential)}']")
  end

end
