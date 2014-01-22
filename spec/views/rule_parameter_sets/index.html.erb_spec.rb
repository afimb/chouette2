require 'spec_helper'

describe "/rule_parameter_sets/index" do

  assign_referential
  let!(:rule_parameter_sets) { assign :rule_parameter_sets, [ Factory(:rule_parameter_set),
                                                              Factory(:rule_parameter_set)] }

  it "should render a show link for each rule_parameter_set" do
    render
    rule_parameter_sets.each do |rule_parameter_set|
      rendered.should have_selector(".rule_parameter_set a[href='#{view.referential_rule_parameter_set_path(referential, rule_parameter_set)}']", :text => rule_parameter_set.name)
    end
  end

  it "should render a link to create a new rule_parameter_set" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_rule_parameter_set_path(referential)}']")
  end

end

