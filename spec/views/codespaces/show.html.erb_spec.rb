require 'spec_helper'

describe "/codespaces/show", :type => :view do
  before do
    allow(view).to receive(:current_user).and_return(double("some policy", admin?: true))
  end

  assign_referential
  let!(:codespace) { assign(:codespace, create(:codespace)) }

  it "should render h2 with the codespace xmlns" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(codespace.xmlns))
  end

  # it "should display a map with class 'codespace'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'codespace')
  # end

  it "should render a link to edit the codespace" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_codespace_path(referential, codespace)}']")
  end

  it "should render a link to remove the codespace" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_codespace_path(referential, codespace)}'][class='remove']")
  end

end

