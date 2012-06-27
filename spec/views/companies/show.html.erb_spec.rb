require 'spec_helper'

describe "/companies/show" do
  
  assign_referential
  let!(:company) { assign(:company, create(:company)) }

  it "should render h2 with the company name" do
    render
    rendered.should have_selector("h2", :text => Regexp.new(company.name))
  end

  # it "should display a map with class 'company'" do
  #   render
  #   rendered.should have_selector("#map", :class => 'company')
  # end

  it "should render a link to edit the company" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.edit_referential_company_path(referential, company)}']")
  end

  it "should render a link to remove the company" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{view.referential_company_path(referential, company)}'][class='remove']")
  end

end

