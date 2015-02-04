# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Group of lines", :type => :feature do
  login_user

  let!(:network) { Factory(:network) }
  let!(:company) { Factory(:company) }
  let!(:line) { Factory(:line, :network => network, :company => company) }
  let!(:group_of_lines) { Array.new(2) { Factory(:group_of_line) } }
  subject { group_of_lines.first }

  describe "list" do
    it "display group of lines" do
      visit referential_group_of_lines_path(referential)
      expect(page).to have_content(group_of_lines.first.name)
      expect(page).to have_content(group_of_lines.last.name)
    end    
  end

  describe "show" do      
    it "display group of line" do
      visit referential_group_of_lines_path(referential)
      click_link "#{subject.name}"
      expect(page).to have_content(subject.name)
    end

    it "display map" do
      visit referential_group_of_lines_path(referential)
      click_link "#{subject.name}"
      expect(page).to have_selector("#map.group_of_line")
    end
  end

  describe "new" do      
    it "creates group of line and return to show" do
      visit referential_group_of_lines_path(referential)
      click_link "Ajouter un groupe de ligne"
      fill_in "group_of_line[name]", :with => "Group of lines 1"
      fill_in "group_of_line[registration_number]", :with => "1"
      fill_in "group_of_line[objectid]", :with => "test:GroupOfLine:999"
      click_button("Créer groupe de ligne")
      expect(page).to have_content("Group of lines 1")
    end
  end

  describe "edit and return to show" do      
    it "edit line" do
      visit referential_group_of_line_path(referential, subject)
      click_link "Modifier ce groupe de lignes"
      fill_in "group_of_line[name]", :with => "Group of lines Modified"
      fill_in "group_of_line[registration_number]", :with => "test-1"
      click_button("Modifier groupe de lignes")
      expect(page).to have_content("Group of lines Modified")
    end
  end


end
