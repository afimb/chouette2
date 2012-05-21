# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Lines" do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:network) { Factory(:network) }
  let!(:company) { Factory(:company) }
  let!(:lines) { referential; Array.new(2) { Factory(:line, :network => network, :company => company) } }
  subject { lines.first }

  describe "list" do
    it "display lines" do
      visit referential_lines_path(referential)
      page.should have_content(lines.first.name)
      page.should have_content(lines.last.name)
    end
    
  end
  

  describe "show" do      
    it "display line" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_lines_path(referential)
      click_link "#{lines.first.name}"
      page.should have_content(lines.first.name)
    end

    it "display map" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_lines_path(referential)
      click_link "#{lines.first.name}"
      page.should have_selector("#map", :class => 'line')
    end
    
  end

  describe "new" do      
    it "creates line and return to show" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_lines_path(referential)
      click_link "Ajouter une ligne"
      fill_in "Nom", :with => "Line 1"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      fill_in "Identifiant Neptune", :with => "test:Line:1"        
      click_button("Créer ligne")
      page.should have_content("Line 1")
    end
  end

  describe "edit and return to show" do      
    it "edit line" do
      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
      visit referential_line_path(referential, subject)
      click_link "Modifier cette ligne"
      fill_in "Nom", :with => "Line Modified"
      fill_in "Numéro d'enregistrement", :with => "test-1"
      click_button("Modifier ligne")
      page.should have_content("Line Modified")
    end
  end

end
