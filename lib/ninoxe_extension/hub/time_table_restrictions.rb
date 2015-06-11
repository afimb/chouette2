# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module TimeTableRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |jp|
        # HUB-44
        jp.validate :specific_objectid
        # HUB-45
        jp.validates_format_of :comment, :with => %r{\A[\w]{0,75}\z}
      end
    end
    def specific_objectid
      validate_specific_objectid( 6)
    end
  end
end

