require 'spec_helper'

describe "referentials/show.html.erb", :type => :view do
  assign_referential
  
  it "should have a title with name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(referential.name))
  end

end
