require 'spec_helper'

describe "/connection_links/new", :type => :view do
  assign_referential
  let!(:connection_link) { assign(:connection_link, build(:connection_link)) }

  describe "form" do
    
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][name=?]", connection_link.name
      end
    end

  end
end
