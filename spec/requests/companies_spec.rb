require 'spec_helper'

describe "Companies" do
  login_user

  let!(:referential) { Factory(:referential).switch }
  let!(:companies) { referential; Array.new(2) { Factory(:company) } }

  describe "GET /companies" do
    it "should display company names" do
      visit referential_companies_path(referential)
      page.should have_content(companies.first.name)
    end
  end
end
