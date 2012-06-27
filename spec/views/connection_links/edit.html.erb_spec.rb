require 'spec_helper'

describe "/connection_links/edit" do
  assign_referential
  let!(:connection_link) { assign(:connection_link, create(:connection_link)) }
  let!(:connection_links) { Array.new(2) { create(:connection_link) } }

  describe "test" do
    it "should render h2 with the connection_link name" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(connection_link.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][name='connection_link[name]'][value=?]", connection_link.name
      end
    end
  end

end
