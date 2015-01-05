# -*- coding: utf-8 -*-
require 'spec_helper'

describe "JourneyPatterns", :type => :feature do
  login_user

  let(:line) { Factory(:line) }
  let(:route) { Factory(:route, :line => line) }
  let(:journey_pattern) { Factory(:journey_pattern, :route => route) }

  describe "from routes page to a journey_pattern page" do
    it "display route's journey_patterns" do
      pending
      visit referential_line_route_path(referential,line,route)
      expect(page).to have_content(journey_pattern.name)
    end
  end
  describe "from route's page to journey_pattern's page" do
    it "display journey_pattern properties" do
      pending
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      expect(page).to have_content(journey_pattern.published_name)
      expect(page).to have_content(journey_pattern.comment)
      expect(page).to have_content(journey_pattern.registration_number)
    end
  end
  describe "from route's page, create a new journey_pattern" do      
    it "return to route's page that display new journey_pattern" do
      pending
      visit referential_line_route_path(referential,line,route)
      click_link "Ajouter une mission"
      fill_in "Nom", :with => "A to B"
      fill_in "Comment", :with => "AB"
      click_button("Créer mission")
      expect(page).to have_content("A to B")
    end
  end
  describe "from route's page, select a journey_pattern and edit it" do      
    it "return to route's page with changed name" do
      pending
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      click_link "Modifier cette mission"
      fill_in "Nom", :with => "#{journey_pattern.name}-changed"
      click_button("Modifier mission")
      expect(page).to have_content("#{journey_pattern.name}-changed")
    end
  end
  describe "from route's page, select a journey_pattern and delete it" do      
    it "return to route's page without journey_pattern name" do
      pending
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      click_link "Supprimer cette mission"
      expect(page).not_to have_content(journey_pattern.name)
    end
  end
end

