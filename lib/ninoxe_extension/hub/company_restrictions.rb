module NinoxeExtension::Hub
  module CompanyRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |g|
        # HUB-7
        g.validate :specific_objectid
        # HUB-8
        #g.validates_length_of :name, :minimum => 1, :maximum => 75
        g.validates :name, length: { in: 1..75 }
        # HUB-9
        #g.validates_format_of :registration_number, :with => %r{\A[\d]{1,8}\z}
        #g.validates_uniqueness_of :registration_number
        g.validates :registration_number,
                    uniqueness: true,
                    length: { in: 1..8 },
                    numericality: { only_integer: true }
      end
    end
    def specific_objectid
      validate_specific_objectid(3)
    end
  end
end

