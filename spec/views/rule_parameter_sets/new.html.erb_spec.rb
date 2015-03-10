require 'spec_helper'

describe "/rule_parameter_sets/new", :type => :view do
  
  assign_organisation
  let!(:organisation) { create(:organisation) }
  let!(:rule_parameter_set) { assign :rule_parameter_set, build( :rule_parameter_set, :organisation => organisation) }
  
  describe "form" do
    
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "input[type=text][name=?]", rule_parameter_set.name
      end
    end
    it "should render input div for added_mode_parameter_set" do
      render
      expect(rendered).to have_selector("form") do
        with_selector "#added_mode_parameter_set"
      end
    end

  end
  
end

