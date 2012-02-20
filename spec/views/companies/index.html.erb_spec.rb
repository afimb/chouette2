require 'spec_helper'

describe "/companies/index" do

  let!(:referential) { assign( :referential, Factory(:referential) ) }
  let!(:companies) { assign( :companies, Array.new(2) { Factory(:company) } )  }  

  it "should render a show link for each group" do        
    render  
    companies.each do |company|      
      rendered.should have_selector(".company a[href='#{view.referential_company_path(referential, company)}']", :text => company.name)
    end
  end

  it "should render a link to create a new group" do
    render
    view.content_for(:sidebar).should have_selector(".actions a[href='#{new_referential_company_path(referential)}']")
  end

end
