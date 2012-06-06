require 'spec_helper'

describe "imports/new.html.erb" do

  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:import) { assign(:import, NeptuneImport.new) }

  let!(:available_imports) { assign(:available_imports, []) }

  it "should display a select to choose import type" do
    render
    rendered.should have_selector("select", :name => "import[type]")
  end

end
