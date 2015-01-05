require 'spec_helper'

describe "/companies/edit", :type => :view do
  assign_referential
  let!(:company) { assign(:company, create(:company)) }
  let!(:companies) { Array.new(2) { create(:company) } }

  describe "test" do
    it "should render h2 with the company name" do
      render    
      expect(rendered).to have_selector("h2", :text => Regexp.new(company.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      expect(rendered).to have_selector("form") do
        with_tag "input[type=text][name='company[name]'][value=?]", company.name
      end
    end
  end

end
