require 'spec_helper'

describe "Networks" do
  login_user

  let!(:referential) { create(:referential).switch }  
  let!(:networks) { referential; Array.new(2) { create(:network) } }

  describe "GET /networks" do
    it "works! (now write some real specs)" do
      visit referential_networks_path(referential)
      page.should have_content(networks.first.name)
    end
  end
end
