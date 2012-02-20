require 'spec_helper'

describe "Networks" do
  let!(:referential) { Factory(:referential) }  
  let!(:networks) { Array.new(2) { Factory(:network) } }

  describe "GET /networks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit referential_networks_path(referential)
      page.should have_content(networks.first.name)
    end
  end
end
