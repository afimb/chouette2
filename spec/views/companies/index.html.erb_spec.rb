require 'spec_helper'

describe "/lines/index" do

  let!(:referential) { assign( :referential, Factory(:referential) ) }
  let!(:network) { Factory(:network) }
  let!(:company) { Factory(:company) }
  let!(:lines) { assign( :lines, Array.new(2) { Factory(:line, :network => network, :company => company) } )  }  

  before :each do
    rendered.stub(:collection).and_return( lines.order_by [[:number, :asc]] )    
    view.stub(:link_to_order).and_return( "#" )
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
