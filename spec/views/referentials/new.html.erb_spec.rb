require 'spec_helper'

describe "referentials/new.html.erb" do

  let!(:referential) { assign(:referential, Referential.new) }
  
  it "should have a textfield for name" do
    render
    rendered.should have_selector("input", :name => "referential[name]")
  end

  it "should have a textfield for slug" do
    render
    rendered.should have_selector("input", :name => "referential[slug]")
  end

end
