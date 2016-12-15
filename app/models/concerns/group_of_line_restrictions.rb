module GroupOfLineRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions

    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |g|
      # HUB-12
      #g.validates_length_of :name, :minimum => 1, :maximum => 75
      g.validates :name, length: { in: 1..75 }
      # HUB-13
      #g.validates_format_of :registration_number, :with => %r{\A[\d]{1,8}\z}
      #g.validates_uniqueness_of :registration_number
      g.validates :registration_number,
                  uniqueness: true,
                  numericality: { only_integer: true },
                  length: { in: 1..8 }
    end

    def self.specific_objectid_size
      6
    end
  end
end
