# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ConnectionLinks", :type => :feature do
  login_user

  let!(:connection_links) { Array.new(2) { create(:connection_link) } }
  subject { connection_links.first }

  describe "list" do
    it "display connection_links" do
      visit referential_connection_links_path(referential)
      expect(page).to have_content(connection_links.first.name)
      expect(page).to have_content(connection_links.last.name)
    end
    
  end 

  describe "show" do      
    it "display connection_link" do
      visit referential_connection_links_path(referential)
      click_link "#{connection_links.first.name}"
      expect(page).to have_content(connection_links.first.name)
    end
    
    it "display map" do
      allow(subject).to receive(:stop_areas).and_return(Array.new(2) { create(:stop_area) })
      visit referential_connection_links_path(referential)
      click_link "#{connection_links.first.name}"
      expect(page).to have_selector("#map.connection_link")
    end
    
  end

  describe "new" do     
    it "creates connection_link and return to show" do
      visit referential_connection_links_path(referential)
      click_link I18n.t("connection_links.actions.new")
      fill_in I18n.t("activerecord.attributes.connection_link.name"), :with => "ConnectionLink 1"
      fill_in I18n.t("activerecord.attributes.connection_link.objectid"), :with => "test:Company:1"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.connection_link.one')))
      expect(page).to have_content("ConnectionLink 1")
    end
  end

  describe "edit and return to show" do      
    it "edit connection_link" do
      visit referential_connection_link_path(referential, subject)
      click_link I18n.t("connection_links.actions.edit")
      fill_in I18n.t("activerecord.attributes.connection_link.name"), :with => "ConnectionLink Modified"
      click_button(I18n.t('formtastic.update',model: I18n.t('activerecord.models.connection_link.one')))
      expect(page).to have_content("ConnectionLink Modified")
    end
  end

end
