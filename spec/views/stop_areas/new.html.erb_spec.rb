require 'spec_helper'

describe "/stop_areas/new" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:stop_area) { assign(:stop_area, build(:stop_area)) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", stop_area.name
      end
    end

  end
end
