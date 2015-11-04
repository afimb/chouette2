require 'spec_helper'

describe "/timebands/edit", :type => :view do
  assign_referential
  let!(:timeband) { assign(:timeband, create(:timeband) ) }

  describe "test" do
    it "should render h2 with the group name" do
      render
      expect(rendered).to have_selector("h2", text: Regexp.new(timeband.name))
    end
  end

  describe "form" do
    it "should render input for timeband" do
      render
      expect(rendered).to have_selector("form") do
        with_tag "input[type=text][name='timeband[name]'][value=?]", timeband.name
      end
    end

  end
end
