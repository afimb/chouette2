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
      hub_restricted? && physical?
    end
    def commercial_hub_restricted?
      hub_restricted? && commercial?
    end
    def commercial_and_physical_hub_restricted?
      physical_hub_restricted? || commercial_hub_restricted?
    end
    # def specific_objectid
    #   validate_specific_objectid( 12)
    # end

    included do
      include ObjectidRestrictions


      with_options if: :commercial_and_physical_hub_restricted? do |sa|
        # HUB-23
        sa.validate :specific_objectid
        #sa.validates_length_of :name, :minimum => 1, :maximum => 75
        sa.validates :name, length: { in: 1..75 }
      end

      with_options if: :commercial_hub_restricted? do |sa|
        # HUB-24
        #sa.validates_length_of :nearest_topic_name, :maximum => 255, :allow_blank => true, :allow_nil => true
        sa.validates :nearest_topic_name, length: { maximum: 255 }, allow_blank: true
      end

      with_options if: :physical_hub_restricted? do |sa|
        # HUB-25
        #sa.validates_length_of :nearest_topic_name, :maximum => 60, :allow_blank => true, :allow_nil => true
        sa.validates :nearest_topic_name, length: { maximum: 60 }, allow_blank: true
        # HUB-28
        #sa.validates_presence_of :coordinates
        sa.validates :coordinates, presence: true
        # HUB-29
        #sa.validates_length_of :city_name, :minimum => 1, :maximum => 80
        sa.validates :city_name, length: { in: 1..80 }
        # HUB-30
        #sa.validates_format_of :country_code, :with => %r{\A[\d]{5}\z}
        sa.validates :country_code, presence: true, numericality: { only_integer: true }, length: { is: 5 }
        # HUB-31
        #sa.validates_length_of :comment, :maximum => 255, :allow_blank => true, :allow_nil => true
        sa.validates :comment, length: { maximum: 255 }, allow_blank: true
        #sa.validates :registration_number, :numericality => { :less_than => 10 ** 8 }
        sa.validates :registration_number, presence: true, numericality: { less_than: 10 ** 8 }
      end
    end
    def specific_objectid
      validate_specific_objectid(12)
    end
  end
end

