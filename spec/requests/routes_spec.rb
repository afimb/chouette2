# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Routes" do
  login_user

  let!(:referential) { create(:referential).switch }
  let(:line) { Factory(:line) }
  let(:route) { Factory(:route, :line => line) }
  let(:route2) { Factory(:route, :line => line) }

  describe "from lines page to a line page" do
    it "display line's routes" do
      pending
      visit referential_lines_path(referential)
      click_link "#{line.name}"
      page.should have_content(route.name)
      page.should have_content(route2.name)
    end
  end
  describe "from line's page to route's page" do
    it "display route properties" do
      pending
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      page.should have_content(route.name)
      page.should have_content(route.number)
    end
  end
  describe "from line's page, create a new route" do      
    it "return to line's page that display new route" do
      pending
      visit referential_line_path(referential,line)
      click_link "Ajouter une séquence d'arrêts"
      fill_in "Nom", :with => "A to B"
      fill_in "Indice", :with => "AB"
      click_button("Créer Séquence d'arrêts")
      page.should have_content("A to B")
    end
  end
  describe "from line's page, select a route and edit it" do      
    it "return to line's page with changed name" do
      pending
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      click_link "Modifier cette séquence d'arrêts"
      fill_in "Nom", :with => "#{route.name}-changed"
      click_button("Modifier Séquence d'arrêts")
      page.should have_content("#{route.name}-changed")
    end
  end
  describe "from line's page, select a route and delete it" do      
    it "return to line's page without route name" do
      pending
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      #click_link "Supprimer cette séquence d'arrêts"
      #page.should_not have_content(route.name)
    end
  end
end
