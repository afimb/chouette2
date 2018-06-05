# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Routes", :type => :feature do
  login_user

  let!(:line) { create(:line) }
  let!(:route) { create(:route, :line => line) }
  let!(:route2) { create(:route, :line => line) }
  #let!(:stop_areas) { Array.new(4) { create(:stop_area) } }
  let!(:stop_points) { Array.new(4) { create(:stop_point, :route => route) } }
      

  describe "from lines page to a line page" do
    it "display line's routes" do
      visit referential_lines_path(referential)
      click_link "#{line.name}"
      expect(page).to have_content(route.name)
      expect(page).to have_content(route2.name)
    end
  end
  
  describe "from line's page to route's page" do
    it "display route properties" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      expect(page).to have_content(route.name)
      expect(page).to have_content(route.number)
    end
  end
  
  describe "from line's page, create a new route" do      
    it "return to line's page that display new route" do
      visit referential_line_path(referential,line)
      click_link I18n.t("routes.actions.new")
      fill_in "route_name", :with => "A to B"
      fill_in I18n.t("activerecord.attributes.route.number"), :with => "AB"
      select  I18n.t("directions.label.straight_forward"), :from => "route_direction_code"
      select  I18n.t("waybacks.label.straight_forward"), :from => "route_wayback_code"
      click_button(I18n.t('formtastic.create',model: I18n.t('activerecord.models.route.one')))
      expect(page).to have_content("A to B")
    end
  end
  
  describe "from line's page, select a route and edit it" do      
    it "return to line's page with changed name" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      click_link I18n.t("routes.actions.edit")
      fill_in "route_name", :with => "#{route.name}-changed"
      click_button(I18n.t('formtastic.update',model: I18n.t('activerecord.models.route.one')))
      expect(page).to have_content("#{route.name}-changed")
    end
  end
  
  describe "from line's page, select a route and delete it" do      
    it "return to line's page without route name" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      click_link I18n.t("routes.actions.destroy")
      expect(page).not_to have_content(route.name)
    end
  end

  describe "from route's page, select edit boarding/alighting and update it" do
    it "Edits boarding/alighting properties on route stops" do
      visit referential_line_route_path(referential, line, route)
      click_link I18n.t('routes.actions.edit_boarding_alighting')
      expect(page).to have_content(I18n.t('routes.edit_boarding_alighting.title'))
      stop_points.each do |sp|
        expect(page).to have_content(sp.stop_area.name)
        expect(page).to have_content(sp.for_boarding)
        expect(page).to have_content(sp.for_alighting)
      end
    end
  end

  describe "Modifies boarding/alighting properties on route stops" do
    it "Puts (http) an update request" do
      #visit edit_boarding_alighting_referential_line_route_path(referential, line, route)
      visit referential_line_route_path(referential, line, route)
      click_link I18n.t('routes.actions.edit_boarding_alighting')
      #select('', :from => '')
      # Changes the boarding of the first stop
      # Changes the alighting of the last stop
      # save
      #click_button(I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.route.one')))
      click_button('submit')
    end
  end
  
end
