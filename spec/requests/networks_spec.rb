# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Networks" do
  login_user

  let!(:networks) { Array.new(2) { Factory(:network) } }
  subject { networks.first }

  describe "list" do
    it "display networks" do
      visit referential_networks_path(referential)
      page.should have_content(networks.first.name)
      page.should have_content(networks.last.name)
    end
    
  end 

  describe "show" do      
    it "display network" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_networks_path(referential)
      click_link "#{networks.first.name}"
      page.should have_content(networks.first.name)
    end

    it "display map" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_networks_path(referential)
      click_link "#{networks.first.name}"
      page.should have_selector("#map", :class => 'network')
    end
    
  end

  describe "new" do      
    it "creates network and return to show" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_networks_path(referential)
      click_link "Ajouter un réseau"
      fill_in "Nom", :with => "Network 1"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      fill_in "Identifiant Neptune", :with => "test:GroupOfLine:1"        
      click_button("Créer réseau")
      page.should have_content("Network 1")
    end
  end

  describe "edit and return to show" do      
    it "edit network" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_network_path(referential, subject)
      click_link "Modifier ce réseau"
      fill_in "Nom", :with => "Network Modified"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      click_button("Modifier réseau")
      page.should have_content("Network Modified")
    end
  end

  # describe "delete", :js => true do      
  #   it "delete network and return to the list" do
  #     subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })     
  #     visit referential_network_path(referential, subject)
  #     click_link "Supprimer ce réseau"
  #     page.evaluate_script('window.confirm = function() { return true; }')
  #     click_button "Valider"
  #     page.should have_no_content(subject.name)
  #   end

  # end
end
