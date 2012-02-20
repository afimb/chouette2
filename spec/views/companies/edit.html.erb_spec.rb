require 'spec_helper'

describe "/companies/edit" do
  let!(:referential) { assign(:referential, Factory(:referential)) }
  let!(:company) { assign(:company, Factory(:company)) }
  let!(:companies) { Array.new(2) { Factory(:company) } }

  describe "test" do
    it "should render h2 with the company name" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(company.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][name='company[name]'][value=?]", company.name
      end
    end
  end

end
