# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Referentials" do
  login_user

  describe "index" do

    it "should support no referential" do
      visit referentials_path
      page.should have_content("Espace de données")
    end

    context "when several referentials exist" do
                                                
      let!(:referentials) {  Array.new(2) { create(:referential) } } 

      it "should show n referentials" do
        visit referentials_path
        page.should have_content(referentials.first.name)
        page.should have_content(referentials.last.name)
      end
      
    end

  end
  
  describe "create" do
    
    it "should" do
      visit new_referential_path
      fill_in "Nom", :with => "Test"
      fill_in "Code", :with => "test"
      click_button "Créer Espace de données"

      Referential.where(:name => "Test").should_not be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  create(:referential) } 

    it "should" do
      visit referential_path(referential)
      click_link "Supprimer"
      Referential.where(:slug => referential.slug).should be_blank
    end

  end
  
end
