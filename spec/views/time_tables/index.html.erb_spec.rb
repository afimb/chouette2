require 'spec_helper'

describe "/time_tables/index", :type => :view do

  assign_referential
  let!(:time_tables) { assign :time_tables, Kaminari.paginate_array(Array.new(2){ create(:time_table) }).page(1) }
  let!(:search) { assign :q, Ransack::Search.new(Chouette::TimeTable) }

  it "should render a show link for each group" do
    render
    time_tables.each do |time_table|
      expect(rendered).to have_selector(".time_table a[href='#{view.referential_time_table_path(referential, time_table)}']", :text => time_table.comment)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_time_table_path(referential)}']")
  end

end
