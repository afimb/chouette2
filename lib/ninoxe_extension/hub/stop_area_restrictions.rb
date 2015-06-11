# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module StopAreaRestrictions
    extend ActiveSupport::Concern

    def physical?
      self.area_type=="BoardingPosition" ||  self.area_type=="Quay"
    end
    def commercial?
      self.area_type=="CommercialStopPoint"
    end
    def physical_hub_restricted?
      hub_restricted? && commercial?
    end
    def commercial_hub_restricted?
      hub_restricted? && physical?
    end
    def commercial_and_physical_hub_restricted?
      physical_hub_restricted? || commercial_hub_restricted?
    end
    def specific_objectid
      validate_specific_objectid( 12)
    end

    included do
      include ObjectidRestrictions


      with_options if: :commercial_and_physical_hub_restricted? do |sa|
      # HUB-23
        sa.validate :specific_objectid
        sa.validates_format_of :name, :with => %r{\A[\w]{1,75}\z}
      end
      with_options if: :commercial_hub_restricted? do |sa|
        # HUB-24
        validates_format_of :nearest_topic_name, :with => %r{\A[\w]{0,255}\z}
      end

      with_options if: :physical_hub_restricted? do |sa|
        # HUB-25
        sa.validates_format_of :nearest_topic_name, :with => %r{\A[\w]{0,60}\z}
        # HUB-28
        sa.validates_presence_of :longitude
        sa.validates_presence_of :latitude
        # HUB-29
        sa.validates_format_of :city_name, :with => %r{\A[\w]{1,80}\z}
        # HUB-30
        sa.validates_format_of :zip_code, :with => %r{\A[\d]{5}\z}
        # HUB-31
        sa.validates_format_of :comment, :with => %r{\A[\w]{0,255}\z}
        # HUB-32
        sa.validates_format_of :registration_number, :with => %r{\A[\w]{1,8}\z}, :allow_blank => true, :allow_nil => true
      end
    end
    def specific_objectid
      validate_specific_objectid( 12)
    end
  end
end

