module NinoxeExtension::Hub
  module NetworkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |g|
        # HUB-3
        g.validate :specific_objectid
        # HUB-4
        g.validates_format_of :name, :with => %r{\A[\w]{1,75}\z}
        # HUB-5
        g.validates_format_of :registration_number, :with => %r{\A[\d]{1,8}\z}
        g.validates_uniqueness_of :registration_number
      end
    end
    def specific_objectid
      validate_specific_objectid( 3)
    end
  end
end

