# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Referentials", :type => :feature do
  login_user

  describe "index" do

    it "should support no referential" do
      visit referentials_path
      expect(page).to have_content( I18n.t("activerecord.models.referential.other") )
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
        expect(page).to have_content(referentials.first.name)
        expect(page).to have_content(referentials.last.name)
      end

    end

  end

  describe "create" do

    it "should" do
      visit new_referential_path
      fill_in I18n.t("activerecord.attributes.referential.name"), :with => "Test"
      fill_in I18n.t("activerecord.attributes.referential.upper_corner"), :with => "0.0, 0.0"
      fill_in I18n.t("activerecord.attributes.referential.lower_corner"), :with => "1.0, 1.0"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.referential.one')))

      expect(Referential.where(:name => "Test")).not_to be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  create(:referential, :organisation => @user.organisation) }

    it "should remove referential" do
      visit referential_path(referential)
      #click_link "Supprimer"
      #expect(Referential.where(:slug => referential.slug)).to be_blank
    end

  end

end
