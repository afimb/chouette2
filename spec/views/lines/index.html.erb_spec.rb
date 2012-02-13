require 'spec_helper'

describe "/lines/index" do

  let!(:network) { assign( :network, Factory(:network) ) }
  let!(:lines) { assign( :lines, Array.new(2) { Factory(:line, :network => network) } )  }  

  before :each do
    rendered.stub(:collection).and_return( lines.order_by [[:code, :asc]] )    
    view.stub(:link_to_order).and_return( "#" )
  end

  it "should render a show link for each group" do        
    render  
    lines.each do |line|      
      rendered.should have_selector(".line a[href='#{view.line_path(line)}']", :text => line.name)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_network_line_path(network)}']")
  end

end
