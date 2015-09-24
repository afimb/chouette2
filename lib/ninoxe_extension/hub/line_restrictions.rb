# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module LineRestrictions
    extend ActiveSupport::Concern


    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |l|
        # HUB-15
        #l.validates_format_of :objectid, :with => %r{\A\w+:\w+:[\w]{1,14}\z}
        l.validate :specific_objectid
        # HUB-16
        l.validates_format_of :number, :with => %r{\A[\w]{1,6}\z}
        # HUB-17
        #l.validates_format_of :name, :with => %r{\A[\w ]{0,75}\z}
        l.validates_length_of :name, :maximum => 75
        # HUB-21
        l.validates :registration_number, :numericality => { :less_than => 10 ** 8 }
        # HUB-22
        l.validates_uniqueness_of :name, :allow_blank => true
      end
    end

    def specific_objectid
      validate_specific_objectid( 14)
    end
  end
end

