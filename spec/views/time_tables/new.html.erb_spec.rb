require 'spec_helper'

describe "/time_tables/new", :type => :view do
  assign_referential
  let!(:time_table) {  assign(:time_table, build(:time_table)) }

  describe "form" do
    
    it "should render input for comment" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][comment=?]", time_table.comment
      end
    end

  end
end
