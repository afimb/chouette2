# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module LineRestrictions
    extend ActiveSupport::Concern


    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |l|
        # HUB-15
        l.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,14}$}
        # HUB-16
        l.validates_format_of :number, :with => %r{^[\w]{1,6}$}
        # HUB-17
        l.validates_format_of :name, :with => %r{^[\w]{0,75}$}
        # HUB-21
        l.validates :registration_number, :numericality => { :less_than => 10 ** 8 }
        # HUB-22
        l.validates_uniqueness_of :name, :allow_blank => true
      end
    end
  end
end

