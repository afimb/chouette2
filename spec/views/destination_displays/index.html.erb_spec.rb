require 'spec_helper'

describe "/destination_displays/index", :type => :view do
  before do
    allow(view).to receive(:policy).and_return(double("some policy", write?: true))
  end

  assign_referential
  let!(:destination_displays) { assign :destination_displays, Kaminari.paginate_array(Array.new(2) { create(:destination_display) }).page(1)  }
  let!(:search) { assign :q, Ransack::Search.new(Chouette::DestinationDisplay) }

  it "should render a show link for each group" do
    render
    destination_displays.each do |destination_display|
      expect(rendered).to have_selector(".destination_display a[href='#{view.referential_destination_display_path(referential, destination_display)}']", :text => destination_display.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_destination_display_path(referential)}']")
  end

end
