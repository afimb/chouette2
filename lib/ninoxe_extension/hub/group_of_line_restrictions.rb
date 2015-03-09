# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module GroupOfLineRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |g|
        # HUB-11
        g.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,6}$}
        # HUB-12
        g.validates_format_of :name, :with => %r{^[\w]{1,75}$}
        # HUB-13
        g.validates_format_of :registration_number, :with => %r{^[\d]{1,8}$}
        g.validates_uniqueness_of :registration_number
      end
    end
  end
end

