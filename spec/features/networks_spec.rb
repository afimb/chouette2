# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Networks", :type => :feature do
  login_user

  let!(:networks) { Array.new(2) { create(:network) } }
  subject { networks.first }

  describe "list" do
    it "display networks" do
      visit referential_networks_path(referential)
      expect(page).to have_content(networks.first.name)
      expect(page).to have_content(networks.last.name)
    end
    
  end 

  describe "show" do      
    it "display network" do
      allow(subject).to receive(:stop_areas).and_return(Array.new(2) { create(:stop_area) })
      visit referential_networks_path(referential)
      click_link "#{networks.first.name}"
      expect(page).to have_content(networks.first.name)
    end

    it "display map" do
      allow(subject).to receive(:stop_areas).and_return(Array.new(2) { create(:stop_area) })
      visit referential_networks_path(referential)
      click_link "#{networks.first.name}"
      expect(page).to have_selector("#map.network")
    end
    
  end

  describe "new" do      
    it "creates network and return to show" do
      allow(subject).to receive(:stop_areas).and_return(Array.new(2) { create(:stop_area) })
      visit referential_networks_path(referential)
      click_link I18n.t("networks.actions.new")
      fill_in "network_name", :with => "Network 1"
      fill_in I18n.t("activerecord.attributes.network.registration_number"), :with => "test-1"
      fill_in I18n.t("activerecord.attributes.network.objectid"), :with => "test:Network:1"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.network.one')))
      expect(page).to have_content("Network 1")
    end
  end

  describe "edit and return to show" do      
    it "edit network" do
      allow(subject).to receive(:stop_areas).and_return(Array.new(2) { create(:stop_area) })
      visit referential_network_path(referential, subject)
      click_link I18n.t("networks.actions.edit")
      fill_in "network_name", :with => "Network Modified"
      fill_in I18n.t("activerecord.attributes.network.registration_number"), :with => "test-1"
      click_button(I18n.t('formtastic.update',model: I18n.t('activerecord.models.network.one')))
      expect(page).to have_content("Network Modified")
    end
  end

  # describe "delete", :js => true do      
  #   it "delete network and return to the list" do
  #     subject.stub(:stop_areas).and_return(Array.new(2) { create(:stop_area) })     
  #     visit referential_network_path(referential, subject)
  #     click_link "Supprimer ce réseau"
  #     page.evaluate_script('window.confirm = function() { return true; }')
  #     click_button "Valider"
  #     page.should have_no_content(subject.name)
  #   end

  # end
end
