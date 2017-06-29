require 'spec_helper'

describe "/codespaces/edit", :type => :view do
  assign_referential
  let!(:codespace) { assign(:codespace, create(:codespace)) }
  let!(:codespaces) { Array.new(2) { create(:codespace) } }

  describe "test" do
    it "should render h2 with the codespace name" do
      render    
      expect(rendered).to have_selector("h2", :text => Regexp.new(codespace.xmlns))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_tag "input[type=text][name='codespace[name]'][value=?]", codespace.xmlns
      end
    end
  end

end
