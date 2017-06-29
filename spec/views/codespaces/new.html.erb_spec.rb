require 'spec_helper'

describe "/codespaces/new", :type => :view do
  assign_referential
  let!(:codespace) { assign(:codespace, build(:codespace)) }

  describe "form" do
    
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][name=?]", codespace.xmlns
      end
    end

  end
end
