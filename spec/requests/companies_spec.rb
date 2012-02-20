require 'spec_helper'

describe "Companies" do
  let!(:referential) { Factory(:referential) }
  let!(:companies) { Array.new(2) { Factory(:company) } }

  describe "GET /companies" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit referential_companies_path(referential)
      page.should have_content(companies.first.name)
    end
  end
end
