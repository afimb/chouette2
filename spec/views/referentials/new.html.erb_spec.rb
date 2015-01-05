require 'spec_helper'

describe "referentials/new.html.erb", :type => :view do

  assign_referential
  
  it "should have a textfield for name" do
    render
    expect(rendered).to have_selector("input", :name => "referential[name]")
  end

  it "should have a textfield for slug" do
    render
    expect(rendered).to have_selector("input", :name => "referential[slug]")
  end

end
