# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module TimeTableRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |jp|
        # HUB-44
        jp.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,6}$}
        # HUB-45
        jp.validates_format_of :comment, :with => %r{^[\w]{0,75}$}
      end
    end
  end
end

