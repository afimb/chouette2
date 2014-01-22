require 'spec_helper'

describe "import_tasks/new.html.erb" do

  assign_referential
  let!(:import_task) { assign(:import_task, ImportTask.new) }

  let!(:available_imports) { assign(:available_imports, []) }

  it "should display a radio button to choose import type" do
    render
    rendered.should have_selector("input", :type => "select", :name => "import_task[format]")
  end

end
