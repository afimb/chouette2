# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Access points", :type => :feature do
  login_user
  
  let!(:stop_area) { create(:stop_area) }
  let!(:access_points) { Array.new(2) { create(:access_point, :stop_area => stop_area) } }
  subject { access_points.first }
  
  describe "list" do

    it "displays a list of access points" do
      visit referential_stop_area_access_points_path(referential, stop_area)
      #save_and_open_page
      access_points.each do |ap|
        expect(page).to have_content(ap.name)
      end
    end

  end
  
  describe "show" do

    it "displays an access point" do
      access_points.each do |ap|
        visit referential_stop_area_path(referential, stop_area)
        click_link ap.name
        expect(page).to have_content(ap.name)
      end
    end
    
    it "displays a map" do
      access_points.each do |ap|
        visit referential_stop_area_path(referential, stop_area)
        click_link ap.name
        expect(page).to have_selector("#map.access_point")
      end
    end
    
  end
  
  describe "new" do
    it "creates an access point" do
      visit referential_stop_area_path(referential, stop_area)
      click_link I18n.t("access_points.actions.new")
      fill_in "access_point[name]", :with => "My Access Point Name"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.access_point.one')))
      expect(page).to have_content("My Access Point Name")
    end
  end
  
  describe "edit" do
    it "edits an acess point" do
      visit referential_stop_area_access_point_path(referential, stop_area, subject)
      click_link I18n.t("access_points.actions.edit")
      fill_in "access_point[name]", :with => "My New Access Point Name"
      click_button(I18n.t('formtastic.update',model: I18n.t('activerecord.models.access_point.one')))
      expect(page).to have_content("My New Access Point Name")
    end
  end
  
end
