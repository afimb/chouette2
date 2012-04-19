require 'spec_helper'

describe "/networks/new" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:network) {  assign(:network, build(:network)) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", network.name
      end
    end

  end
end
