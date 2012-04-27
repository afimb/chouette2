require 'spec_helper'

describe "/connection_links/index" do

  let!(:referential) { assign( :referential, create(:referential) ) }
  let!(:connection_links) { assign :connection_links, Array.new(2) { create(:connection_link) }.paginate  }  
  let!(:search) { assign :q, Ransack::Search.new(Chouette::ConnectionLink) }

  it "should render a show link for each group" do        
    render  
    connection_links.each do |connection_link|      
      rendered.should have_selector(".connection_link a[href='#{view.referential_connection_link_path(referential, connection_link)}']", :text => connection_link.name)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_connection_link_path(referential)}']")
  end

end
