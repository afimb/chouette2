require 'spec_helper'

describe "/connection_links/index", :type => :view do

  assign_referential
  let!(:connection_links) { assign :connection_links, Kaminari.paginate_array(Array.new(2) { create(:connection_link) }).page(1) }
  let!(:search) { assign :q, Ransack::Search.new(Chouette::ConnectionLink) }

  it "should render a show link for each group" do
    render
    connection_links.each do |connection_link|
      expect(rendered).to have_selector(".connection_link a[href='#{view.referential_connection_link_path(referential, connection_link)}']", :text => connection_link.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_connection_link_path(referential)}']")
  end

end
