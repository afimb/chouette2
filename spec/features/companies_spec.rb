# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Companies", :type => :feature do
  login_user

  let!(:companies) { Array.new(2) { create :company } }
  subject { companies.first }

  describe "list" do
    it "display companies" do
      visit referential_companies_path(referential)
      expect(page).to have_content(companies.first.name)
      expect(page).to have_content(companies.last.name)
    end
    
  end 

  describe "show" do      
    it "display company" do
      visit referential_companies_path(referential)
      click_link "#{companies.first.name}"
      expect(page).to have_content(companies.first.name)
    end
    
  end

  describe "new" do      
    it "creates company and return to show" do
      visit referential_companies_path(referential)
      click_link "Ajouter un transporteur"
      fill_in "company_name", :with => "Company 1"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      fill_in "Identifiant Neptune", :with => "test:Company:1"        
      click_button("Créer transporteur")
      expect(page).to have_content("Company 1")
    end
  end

  describe "edit and return to show" do      
    it "edit company" do
      visit referential_company_path(referential, subject)
      click_link "Modifier ce transporteur"
      fill_in "company_name", :with => "Company Modified"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      click_button("Modifier transporteur")
      expect(page).to have_content("Company Modified")
    end
  end

end
