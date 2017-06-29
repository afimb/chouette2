require 'spec_helper'

describe "/destination_displays/edit", :type => :view do
  assign_referential
  let!(:destination_display) { assign(:destination_display, create(:destination_display)) }
  let!(:destination_displays) { Array.new(2) { create(:destination_display) } }

  describe "test" do
    it "should render h2 with the destination_display name" do
      render    
      expect(rendered).to have_selector("h2", :text => Regexp.new(destination_display.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_tag "input[type=text][name='destination_display[name]'][value=?]", destination_display.name
      end
    end
  end

end
