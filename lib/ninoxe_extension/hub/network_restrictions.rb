module NinoxeExtension::Hub
  module NetworkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |g|
        # HUB-3
        g.validates_format_of :objectid, :with => %r{^\w+:\w+:[\w]{1,3}$}
        # HUB-4
        g.validates_format_of :name, :with => %r{^[\w]{1,75}$}
        # HUB-5
        g.validates_format_of :registration_number, :with => %r{^[\d]{1,8}$}
        g.validates_uniqueness_of :registration_number
      end
    end
  end
end

