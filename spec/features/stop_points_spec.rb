# -*- coding: utf-8 -*-
require 'spec_helper'

describe "StopPoints", :type => :feature do
  login_user

  let!(:line) { create(:line) }
  let!(:route) { create(:route, :line => line) }
  let!(:route2) { create(:route, :line => line) }
  
  describe "from route's page, go to new stop point page" do
    it "display route's stop points" do
      visit referential_line_route_path(referential,line,route)
      # click_link "Liste des arrêts de la séquence d'arrêts"
      # click_link "Ajouter un arrêt à la séquence"
      # expect(page).to have_content( "Sélectionner un arrêt")
    end
  end
end
