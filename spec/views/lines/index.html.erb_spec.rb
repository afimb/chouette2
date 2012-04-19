require 'spec_helper'

describe "/lines/index" do

  let!(:referential) { assign :referential, create(:referential) }
  let!(:network) { create :network }
  let!(:company) { create :company }
  let!(:lines) { assign :lines, Array.new(2) { create(:line, :network => network, :company => company) }.paginate }  
  let!(:q) { assign :q, Ransack::Search.new(Chouette::Line) }

  before :each do
    view.stub(:link_with_search).and_return("#")
  end

  it "should render a show link for each group" do        
    render  
    lines.each do |line|      
      rendered.should have_selector(".line a[href='#{view.referential_line_path(referential, line)}']", :text => line.name)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_line_path(referential)}']")
  end

end
