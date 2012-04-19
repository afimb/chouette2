require 'spec_helper'

describe "/companies/new" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:company) { assign(:company, build(:company)) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", company.name
      end
    end

  end
end
