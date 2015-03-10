# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module VehicleJourneyRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      # HUB-42
      with_options if: :hub_restricted? do |jp|
        jp.validates_format_of :objectid, :with => %r{\A\w+:\w+:[\w]{1,8}\z}
      end
    end
  end
end

