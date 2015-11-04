require 'spec_helper'

describe "/timebands/new", :type => :view do
  assign_referential
  let!(:timeband) {  assign(:timeband, build(:timeband)) }

  describe "form" do

    it "should render inputs" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][name=?]", timeband.name
        with_selector "select[start_time(4i)=?]", timeband.start_time
        with_selector "select[start_time(5i)=?]", timeband.start_time
        with_selector "select[end_time(4i)=?]", timeband.end_time
        with_selector "select[end_time(5i)=?]", timeband.end_time
      end
    end

  end
end
