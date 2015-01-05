require 'spec_helper'

describe "/networks/edit", :type => :view do
  assign_referential
  let!(:network) { assign(:network, create(:network) ) }

  describe "test" do
    it "should render h2 with the group name" do
      render    
      expect(rendered).to have_selector("h2", :text => Regexp.new(network.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_tag "input[type=text][name='network[name]'][value=?]", network.name
      end
    end

  end
end
