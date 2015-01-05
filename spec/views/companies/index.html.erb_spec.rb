require 'spec_helper'

describe "/companies/index", :type => :view do

  assign_referential
  let!(:companies) { assign :companies, Array.new(2) { create(:company) }.paginate  }  
  let!(:search) { assign :q, Ransack::Search.new(Chouette::Company) }

  it "should render a show link for each group" do        
    render  
    companies.each do |company|      
      expect(rendered).to have_selector(".company a[href='#{view.referential_company_path(referential, company)}']", :text => company.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_company_path(referential)}']")
  end

end
