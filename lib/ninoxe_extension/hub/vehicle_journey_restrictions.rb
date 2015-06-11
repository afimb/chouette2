# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module VehicleJourneyRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      # HUB-42
      with_options if: :hub_restricted? do |jp|
        jp.validate :specific_objectid
      end
    end
    def specific_objectid
      validate_specific_objectid( 8)
    end
  end
end

