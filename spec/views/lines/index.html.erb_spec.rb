require 'spec_helper'

describe "/lines/index", :type => :view do

  assign_user
  assign_referential
  let!(:network) { create :network }
  let!(:company) { create :company }
  let!(:lines) { assign :lines, Kaminari.paginate_array(Array.new(2) { create(:line, :network => network, :company => company) }).page(1) }
  let!(:q) { assign :q, Ransack::Search.new(Chouette::Line) }

  before :each do
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive(:link_with_search).and_return("#")
  end

  it "should render a show link for each group" do
    render
    lines.each do |line|
      expect(rendered).to have_selector(".line a[href='#{view.referential_line_path(referential, line)}']", :text => line.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_line_path(referential)}']")
  end

end
