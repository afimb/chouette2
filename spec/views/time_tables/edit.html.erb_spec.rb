require 'spec_helper'

describe "/time_tables/edit" do
  assign_referential
  let!(:time_table) { assign(:time_table, create(:time_table) ) }

  describe "test" do
    it "should render h2 with the group comment" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(time_table.comment))
    end
  end

  describe "form" do
    it "should render input for comment" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][comment='time_table[comment]'][value=?]", time_table.comment
      end
    end

  end
end
