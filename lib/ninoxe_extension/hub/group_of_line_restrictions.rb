# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module GroupOfLineRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |g|
        # HUB-11
        g.validate :specific_objectid
        # HUB-12
        #g.validates_format_of :name, :with => %r{\A[\w ]{1,75}\z}
        g.validates_length_of :name, :minimum => 1, :maximum => 75
        # HUB-13
        g.validates_format_of :registration_number, :with => %r{\A[\d]{1,8}\z}
        g.validates_uniqueness_of :registration_number
      end
    end
    def specific_objectid
      validate_specific_objectid( 6)
    end
  end
end

