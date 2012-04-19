require 'spec_helper'

describe "/lines/new" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:network) { create(:network) }
  let!(:company) { create(:company) }
  let!(:line) { assign(:line, build(:line, :network => network, :company => company )) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", line.name
      end
    end

  end
end
