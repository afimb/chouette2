# -*- coding: utf-8 -*-
require 'spec_helper'

describe "StopAreas" do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:stop_areas) { referential; Array.new(2) { Factory(:stop_area) } }
  subject { stop_areas.first }

  describe "list" do
    it "display stop_areas" do
      visit referential_stop_areas_path(referential)
      page.should have_content(stop_areas.first.name)
      page.should have_content(stop_areas.last.name)
    end
    
  end
  

  describe "show" do      
    it "display stop_area" do
      visit referential_stop_areas_path(referential)
      click_link "#{stop_areas.first.name}"
      page.should have_content(stop_areas.first.name)
    end

    it "display map" do
      visit referential_stop_areas_path(referential)
      click_link "#{stop_areas.first.name}"
      page.should have_selector("#map", :class => 'stop_area')
    end
    
  end

  describe "new" do      
    it "creates stop_area and return to show" do
      visit referential_stop_areas_path(referential)
      click_link "Ajouter un arrêt"
      fill_in "Nom", :with => "StopArea 1"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      #fill_in "Identifiant Neptune", :with => "test:StopArea:1"        
      click_button("Créer arrêt")
      page.should have_content("StopArea 1")
    end
  end

  describe "edit and return to show" do      
    it "edit stop_area" do
      visit referential_stop_area_path(referential, subject)
      click_link "Modifier cet arrêt"
      fill_in "Nom", :with => "StopArea Modified"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      click_button("Modifier arrêt")
      page.should have_content("StopArea Modified")
    end
  end

end
