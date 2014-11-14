# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Referentials" do
  login_user

  describe "index" do

    it "should support no referential" do
      visit referentials_path
      page.should have_content("Espaces de Données")
    end

    context "when several referentials exist" do

      def retrieve_referential_by_slug( slug)
        @user.organisation.referentials.find_by_slug(slug) || 
          create(:referential, :slug => slug, :name => slug, :organisation => @user.organisation)
      end
                                                
      let!(:referentials) { [ retrieve_referential_by_slug("aa"),
                              retrieve_referential_by_slug("bb")] }  

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
      fill_in "Point haut/droite de l'emprise par défaut", :with => "0.0, 0.0"
      fill_in "Point bas/gauche de l'emprise par défaut", :with => "1.0, 1.0"
      click_button "Créer Espace de Données"

      Referential.where(:name => "Test").should_not be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  create(:referential, :organisation => @user.organisation) } 

    it "should remove referential" do
      pending "Unauthorized DELETE (ticket #14)"
      visit referential_path(referential)
      click_link "Supprimer"
      Referential.where(:slug => referential.slug).should be_blank
    end

  end
  
end
