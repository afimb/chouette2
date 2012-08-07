# -*- coding: utf-8 -*-
require 'spec_helper'

describe "StopPoints" do
  login_user

  let(:line) { Factory(:line) }
  let(:route) { Factory(:route, :line => line) }
  let(:route2) { Factory(:route, :line => line) }

  describe "from route's page to a stop points page" do
    it "display route's stop points" do
      pending
      visit referential_line_route_path(referential,line,route)
      click_link "Gérer les arrêts de la séquence"
      route.stop_areas.each do |sa|
        page.should have_content(sa.name)
      end
    end
  end
  describe "from route's page, go to new stop point page" do
    it "display route's stop points" do
      visit referential_line_route_path(referential,line,route)
      click_link "Gérer les arrêts de la séquence"
      click_link "Ajouter un arrêt à la séquence"
      page.should have_content( "Sélectionner un arrêt")
    end
  end
end
