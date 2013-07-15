require 'spec_helper'

describe "imports/new.html.erb" do

  assign_referential
  let!(:import) { assign(:import, NeptuneImport.new) }

  let!(:available_imports) { assign(:available_imports, []) }

  it "should display a radio button to choose import type" do
    render
    rendered.should have_selector("input", :type => "radio", :name => "import[type]")
  end

end
