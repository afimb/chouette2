# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module StopAreaRestrictions
    extend ActiveSupport::Concern

    included do
      #include ObjectidRestrictions
      def physical?
        self.area_type=="BoardingPosition" ||  self.area_type=="Quay"
      end
      def commercial?
        self.area_type=="CommercialStopPoint"
      end
      def self.physical_hub_restricted?
        Proc.new { |s| s.hub_restricted? && s.commercial?}
      end
      def self.commercial_hub_restricted?
        Proc.new { |s| s.hub_restricted? && s.physical?}
      end
      def self.commercial_and_physical_hub_restricted?
        physical_hub_restricted? || commercial_hub_restricted?
      end


      with_options if: commercial_and_physical_hub_restricted? do |sa|
      # HUB-23
        sa.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,12}$}
        sa.validates_format_of :name, :with => %r{^[\w]{1,75}$}
      end
      with_options if: commercial_hub_restricted? do |sa|
        # HUB-24
        validates_format_of :nearest_topic_name, :with => %r{^[\w]{0,255}$}
      end

      with_options if: physical_hub_restricted? do |sa|
        # HUB-25
        sa.validates_format_of :nearest_topic_name, :with => %r{^[\w]{0,60}$}
        # HUB-28
        sa.validates_presence_of :longitude
        sa.validates_presence_of :latitude
        # HUB-29
        sa.validates_format_of :city_name, :with => %r{^[\w]{1,80}$}
        # HUB-30
        sa.validates_format_of :zip_code, :with => %r{^[\d]{5}$}
        # HUB-31
        sa.validates_format_of :comment, :with => %r{^[\w]{0,255}$}
        # HUB-32
        sa.validates_format_of :registration_number, :with => %r{^[\w]{1,8}$}, :allow_blank => true, :allow_nil => true
      end
    end
  end
end

