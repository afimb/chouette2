# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Lines", :type => :feature do
  login_user

  let!(:network) { Factory(:network) }
  let!(:company) { Factory(:company) }
  let!(:lines) { Array.new(2) { Factory(:line_with_stop_areas, :network => network, :company => company) } }
  subject { lines.first }

  describe "list" do
    it "display lines" do
      visit referential_lines_path(referential)
      expect(page).to have_content(lines.first.name)
      expect(page).to have_content(lines.last.name)
    end
    
  end  

  describe "show" do      
    it "display line" do
      visit referential_lines_path(referential)
      click_link "#{lines.first.name}"
      expect(page).to have_content(lines.first.name)
    end

    it "display map" do
      visit referential_lines_path(referential)
      click_link "#{lines.first.name}"
      expect(page).to have_selector("#map.line")
    end
    
  end

  describe "new" do      
    it "creates line and return to show" do
      visit referential_lines_path(referential)
      click_link "Ajouter une ligne"
      fill_in "line_name", :with => "Line 1"
      fill_in "Numéro d'enregistrement", :with => "1"
      fill_in "Identifiant Neptune", :with => "test:Line:999"        
      click_button("Créer ligne")
      expect(page).to have_content("Line 1")
    end
  end

  describe "edit and return to show" do      
    it "edit line" do
      visit referential_line_path(referential, subject)
      click_link "Modifier cette ligne"
      fill_in "line_name", :with => "Line Modified"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      click_button("Modifier ligne")
      expect(page).to have_content("Line Modified")
    end
  end

end
