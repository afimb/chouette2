# -*- coding: utf-8 -*-
require 'spec_helper'

describe "ConnectionLinks" do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:connection_links) { referential; Array.new(2) { create(:connection_link) } }
  subject { connection_links.first }

  describe "list" do
    it "display connection_links" do
      visit referential_connection_links_path(referential)
      page.should have_content(connection_links.first.name)
      page.should have_content(connection_links.last.name)
    end
    
  end 

  describe "show" do      
    it "display connection_link" do
      visit referential_connection_links_path(referential)
      click_link "#{connection_links.first.name}"
      page.should have_content(connection_links.first.name)
    end
    
    it "display map" do
      pending ": map not yet implemented"
#      subject.stub(:stop_areas).and_return(Array.new(2) { Factory(:stop_area) })
#      visit referential_connection_links_path(referential)
#      click_link "#{connection_links.first.name}"
#      page.should have_selector("#map", :class => 'connection_link')
    end
    
  end

  describe "new" do     
    it "creates connection_link and return to show" do
      visit referential_connection_links_path(referential)
      click_link "Ajouter une correspondance"
      fill_in "Nom", :with => "ConnectionLink 1"
      fill_in "Identifiant Neptune", :with => "test:ConnectionLink:1"        
      click_button("Créer Correspondance")
      page.should have_content("ConnectionLink 1")
    end
  end

  describe "edit and return to show" do      
    it "edit connection_link" do
      visit referential_connection_link_path(referential, subject)
      click_link "Modifier cette correspondance"
      fill_in "Nom", :with => "ConnectionLink Modified"
      click_button("Modifier Correspondance")
      page.should have_content("ConnectionLink Modified")
    end
  end

end
