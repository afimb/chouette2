require 'spec_helper'

describe "referentials/show.html.erb" do
  let!(:referential) { assign(:referential, create(:referential)) }
  
  it "should have a title with name" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(referential.name))
  end

end
