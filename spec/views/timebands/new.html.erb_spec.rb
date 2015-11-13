require 'spec_helper'

describe "/timebands/new", :type => :view do
  assign_referential
  let!(:timeband) {  assign(:timeband, build(:timeband)) }

  describe "form" do

    it "should render inputs" do
      render
      expect(rendered).to have_field('timeband[name]')
      expect(rendered).to have_field('timeband[start_time(4i)]')
      expect(rendered).to have_field('timeband[start_time(5i)]')
      expect(rendered).to have_selector('button[type=submit]')
    end

  end
end
