require 'spec_helper'

describe "/organisations/show" do

  assign_user
  assign_organisation

  let!(:organisation) { create(:organisation) }
  let!(:rule_parameter_sets) { assign :rule_parameter_sets, [ create(:rule_parameter_set, :organisation => organisation),
                                                              create(:rule_parameter_set, :organisation => organisation)] }
  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  it "should render a show link for each rule_parameter_set" do
    render
    rule_parameter_sets.each do |rule_parameter_set|
      #rendered.should have_selector(".rule_parameter_sets a[href='#{view.organisation_rule_parameter_set_path( rule_parameter_set)}']", :text => rule_parameter_set.name)
    end
  end

  it "should render a link to create a new rule_parameter_set" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_organisation_rule_parameter_set_path}']")
  end

end

