# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Routes", :type => :feature do
  login_user

  let!(:line) { Factory(:line) }
  let!(:route) { Factory(:route, :line => line) }
  let!(:route2) { Factory(:route, :line => line) }

  describe "from lines page to a line page" do
    it "display line's routes" do
      visit referential_lines_path(referential)
      click_link "#{line.name}"
      expect(page).to have_content(route.name)
      expect(page).to have_content(route2.name)
    end
  end
  
  describe "from line's page to route's page" do
    it "display route properties" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      expect(page).to have_content(route.name)
      expect(page).to have_content(route.number)
    end
  end
  
  describe "from line's page, create a new route" do      
    it "return to line's page that display new route" do
      visit referential_line_path(referential,line)
      click_link "Ajouter une séquence d'arrêts"
      save_and_open_page
      fill_in "route_name", :with => "A to B"
      fill_in "Indice", :with => "AB"
      select 'aller', :from => "route_direction_code"
      select 'aller', :from => "route_wayback_code" 
      click_button("Créer Séquence d'arrêts")
      expect(page).to have_content("A to B")
    end
  end
  
  describe "from line's page, select a route and edit it" do      
    it "return to line's page with changed name" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      click_link "Modifier cette séquence d'arrêts"
      save_and_open_page
      fill_in "route_name", :with => "#{route.name}-changed"
      save_and_open_page
      click_button("Modifier Séquence d'arrêts")
      expect(page).to have_content("#{route.name}-changed")
    end
  end
  
  describe "from line's page, select a route and delete it" do      
    it "return to line's page without route name" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      click_link "Supprimer cette séquence d'arrêts"
      expect(page).not_to have_content(route.name)
    end
  end
end
