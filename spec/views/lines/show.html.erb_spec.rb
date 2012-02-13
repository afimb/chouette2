require 'spec_helper'

describe "/lines/show" do
  
  let!(:network) { assign(:network, Factory(:network)) }
  let!(:line) { assign(:line, Factory(:line, :network => network)) }
  let!(:map) { assign(:map, LineMap.new(line) ) }

  it "should render h2 with the line name" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(line.name))
  end

  it "should display a map with class 'line'" do
    render
    rendered.should have_selector("#map", :class => 'line')
  end

  it "should render a link to edit the line" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.edit_line_path(line)}']")
  end

  it "should render a link to remove the line" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.line_path(line)}'][class='remove']")
  end

end

