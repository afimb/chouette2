require 'spec_helper'

describe "/rule_parameter_sets/new" do

  assign_referential
  let!(:rule_parameter_set) { assign :rule_parameter_set, build( :rule_parameter_set, :referential => referential) }

  describe "form" do

    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", rule_parameter_set.name
      end
    end
    it "should render input div for added_mode_parameter_set" do
      render
      rendered.should have_selector("form") do
        with_selector "#added_mode_parameter_set"
      end
    end

  end

end

