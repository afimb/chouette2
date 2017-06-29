require 'spec_helper'

describe "/codespaces/index", :type => :view do
  before do
    allow(view).to receive(:current_user).and_return(double("some policy", admin?: true))
  end

  assign_referential
  let!(:codespaces) { assign :codespaces, Kaminari.paginate_array(Array.new(2) { create(:codespace) }).page(1)  }
  let!(:search) { assign :q, Ransack::Search.new(Chouette::Codespace) }

  it "should render a show link for each group" do
    render
    codespaces.each do |codespace|
      expect(rendered).to have_selector(".codespace a[href='#{view.referential_codespace_path(referential, codespace)}']", :text => codespace.xmlns)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_codespace_path(referential)}']")
  end

end
