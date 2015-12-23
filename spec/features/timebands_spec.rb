# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Timebands", :type => :feature do
  login_user

  let!(:timebands) { Array.new(2) { create(:timeband) } }
  subject { timebands.first }

  describe "list" do
    it "display timebands" do
      visit referential_timebands_path(referential)
      expect(page).to have_content(timebands.first.name)
      expect(page).to have_content(timebands.last.name)
    end

  end

  describe "show" do
    it "display timeband" do
      visit referential_timebands_path(referential)
      click_link "#{timebands.first.name}"
      expect(page).to have_content(timebands.first.name)
    end

  end

  describe "new" do
    it "creates timeband and return to show" do
      visit referential_timebands_path(referential)
      click_link "Ajouter un créneau horaire"
      fill_in "Titre", :with => "Timeband 1"

      select '10', from: 'timeband_start_time_4i'
      select '00', from: 'timeband_start_time_5i'
      select '11', from: 'timeband_end_time_4i'
      select '00', from: 'timeband_end_time_5i'

      click_button("Créer créneau horaire")
      expect(page).to have_content("Timeband 1")
    end
  end

  describe "edit and return to show" do
    it "edit timeband" do
      visit referential_timeband_path(referential, subject)
      click_link "Modifier ce créneau horaire"
      fill_in "Titre", :with => "Timeband Modified"
      click_button("Modifier créneau horaire")
      expect(page).to have_content("Timeband Modified")
    end
  end

  describe "delete and return to list" do
    it "delete timeband" do
      visit referential_timebands_path(referential)
      page.all('.remove')[0].click
      expect(page).to_not have_content("Timeband Modified")
    end
  end

end
