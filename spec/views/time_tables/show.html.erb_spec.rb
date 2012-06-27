require 'spec_helper'

describe "/time_tables/show" do
  
  assign_referential
  let!(:time_table) { assign(:time_table, create(:time_table)) }

  it "should render h2 with the time_table comment" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(time_table.comment))
  end

  it "should render a link to edit the time_table" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.edit_referential_time_table_path(referential, time_table)}']")
  end

  it "should render a link to remove the time_table" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.referential_time_table_path(referential, time_table)}'][class='remove']")
  end

end

