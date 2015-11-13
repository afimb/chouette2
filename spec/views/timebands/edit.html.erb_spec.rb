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
      expect(rendered).to have_field('timeband[name]')
      expect(rendered).to have_field('timeband[start_time(4i)]')
      expect(rendered).to have_field('timeband[start_time(5i)]')
      expect(rendered).to have_selector('button[type=submit]')
    end

  end
end
