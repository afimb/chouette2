require 'spec_helper'

describe "/lines/new" do
  let!(:network) { assign(:network, Factory(:network)) }
  let!(:line) { assign(:line, Factory.build(:line, :network => network)) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", line.name
      end
    end

  end
end
