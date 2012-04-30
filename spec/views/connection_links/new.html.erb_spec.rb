require 'spec_helper'

describe "/connection_links/new" do
  let!(:referential) { assign(:referential, create(:referential)) }
  let!(:connection_link) { assign(:connection_link, build(:connection_link)) }

  describe "form" do
    
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_selector "input[type=text][name=?]", connection_link.name
      end
    end

  end
end
