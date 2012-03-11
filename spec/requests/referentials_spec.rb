# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Referentials" do

  describe "index" do
    let!(:referentials) {  Array.new(2) { Factory(:referential) } } 

    it "should show n referentials" do
      visit referentials_path
      page.should have_content(referentials.first.name)
      page.should have_content(referentials.last.name)
    end

  end
  
  describe "create" do
    
    it "should" do
      visit new_referential_path
      fill_in "Nom", :with => "Test"
      fill_in "Code", :with => "test"
      click_button "Créer Référentiel"

      Referential.where(:name => "Test").should_not be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  Factory(:referential) } 

    it "should" do
      visit referential_path(referential)
      click_link "Supprimer"
      Referential.where(:slug => referential.slug).should be_blank
    end

  end
  
end
