require 'spec_helper'

describe "referentials/new.html.erb", :type => :view do

  before(:each) do
    assign(:referential, Referential.new)
  end
  
  it "should have a textfield for name" do
    render
    expect(rendered).to have_field("referential[name]")
  end

  it "should have a textfield for slug" do
    render
    expect(rendered).to have_field("referential[slug]")
  end

end
