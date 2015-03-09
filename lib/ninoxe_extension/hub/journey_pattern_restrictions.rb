# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module JourneyPatternRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |jp|
        # HUB-39
        jp.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,30}$}
        # HUB-40
        jp.validates :registration_number, :numericality => { :less_than => 10 ** 8 }
        # HUB-41
        jp.validates_format_of :name, :with => %r{^[\w]{0,75}$}
      end
    end
  end
end

