# -*- coding: utf-8 -*-
require 'spec_helper'

describe "codespaces", :type => :feature do
  login_admin

  let!(:codespaces) { [
      create(:codespace, :xmlns => "ABC", :xmlns_url => "https://www.mycodepace.com/ns/abc"),
      create(:codespace, :xmlns => "ZXY", :xmlns_url => "https://www.rutebanken.no/ns/zxy")
  ] }
  subject { codespaces.first }

  describe "list" do
    it "display codespaces" do
      visit referential_codespaces_path(referential)
      expect(page).to have_content(codespaces.first.xmlns)
      expect(page).to have_content(codespaces.last.xmlns)
    end

  end

  describe "show" do
    it "display codespace" do
      visit referential_codespaces_path(referential)
      click_link "#{codespaces.first.xmlns}"
      expect(page).to have_content(codespaces.first.xmlns)
    end

  end

  describe "new" do
    it "creates codespace and return to show" do
      visit referential_codespaces_path(referential)
      click_link I18n.t("codespaces.actions.new")
      fill_in "codespace_xmlns", :with => "DLE"
      fill_in "codespace_xmlns_url", :with => "https://www.rutebanken.no/ns/dle"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.codespace.one')))
      expect(page).to have_content("DLE")
    end
  end

  describe "edit and return to show" do
    it "edit codespace" do
      visit referential_codespace_path(referential, subject)
      click_link I18n.t("codespaces.actions.edit")
      fill_in "codespace_xmlns", :with => "EFR"
      click_button(I18n.t('formtastic.update',model: I18n.t('activerecord.models.codespace.one')))
      expect(page).to have_content("EFR")
    end
  end

end
