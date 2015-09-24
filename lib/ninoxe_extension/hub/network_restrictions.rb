module NinoxeExtension::Hub
  module NetworkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |n|
        # HUB-3
        n.validate :specific_objectid
        # HUB-4
        #n.validates_format_of :name, :with => %r{\A[\w ]{1,75}\z}
        n.validates_length_of :name, :minimum => 1, :maximum => 75
        # HUB-5
        n.validates_format_of :registration_number, :with => %r{\A[\d]{1,8}\z}
        n.validates_uniqueness_of :registration_number
      end
    end
    def specific_objectid
      validate_specific_objectid( 3)
    end
  end
end

