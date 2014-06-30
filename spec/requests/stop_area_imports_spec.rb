# -*- coding: utf-8 -*-
require 'spec_helper'

describe "StopAreaImports" do
  login_user

  let!(:line) { create :line }
  let!(:valid_file_path) { Rails.root + "spec/fixtures/stop_area_import_valid.csv" }
  let!(:invalid_file_path) { Rails.root + "spec/fixtures/stop_area_import_invalid.csv" }
  
  describe "new" do      
    it "should create stop areas and return to stop areas index page" do
      visit new_referential_stop_area_import_path(referential)
      attach_file('Fichier', valid_file_path)
      click_button "Lancer l'import"
      expect(page).to have_content(I18n.t("stop_area_imports.new.success"))
      expect(page).to have_content("StopArea1")
    end

    it "should return error messages when file is invalid" do
      visit new_referential_stop_area_import_path(referential)
      attach_file('Fichier', invalid_file_path)
      click_button "Lancer l'import"
      expect(page).to have_content(I18n.t("stop_area_imports.errors.import_aborted"))
    end
    
    it "should return error message when file missing on upload" do
      visit new_referential_stop_area_import_path(referential)
      click_button "Lancer l'import"
      expect(page).to have_content(I18n.t("stop_area_imports.errors.import_aborted"))
    end    
  end
  
end
