require 'spec_helper'

describe "/stop_areas/edit" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:stop_area) { assign(:stop_area, create(:stop_area)) }
  let!(:map) { assign(:map, mock(:to_html => '<div id="map"/>'.html_safe)) }

  describe "test" do
    it "should render h2 with the group name" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(stop_area.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][name='stop_area[name]'][value=?]", stop_area.name
      end
    end

  end
end
