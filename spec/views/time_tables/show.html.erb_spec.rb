require 'spec_helper'

describe "/time_tables/show", :type => :view do

  assign_user
  assign_referential
  let!(:time_table) { assign(:time_table, create(:time_table)) }
  let!(:year) { assign(:year, Date.today.cwyear) }
  let!(:time_table_combination) {assign(:time_table_combination, TimeTableCombination.new)}

  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  it "should render h2 with the time_table comment" do    
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(time_table.comment))
  end

  it "should render a link to edit the time_table" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_time_table_path(referential, time_table)}']")
  end

  it "should render a link to remove the time_table" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_time_table_path(referential, time_table)}'][class='remove']")
  end

end

