require 'spec_helper'

describe "/time_tables/index" do

  let!(:referential) { assign :referential, create(:referential) }
  let!(:time_tables) { assign :time_tables, Array.new(2){ create(:time_table) }.paginate }  
  let!(:search) { assign :q, Ransack::Search.new(Chouette::TimeTable) }

  it "should render a show link for each group" do        
    render  
    time_tables.each do |time_table|      
      rendered.should have_selector(".time_table a[href='#{view.referential_time_table_path(referential, time_table)}']", :text => time_table.comment)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_time_table_path(referential)}']")
  end

end
