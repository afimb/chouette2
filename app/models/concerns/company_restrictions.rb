module CompanyRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions

    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |g|
      # HUB-8
      g.validates :name, length: { in: 1..75 }

      # HUB-9
      g.validates :registration_number,
                  uniqueness: true,
                  length: { in: 1..8 },
                  numericality: { only_integer: true }
    end

    def self.specific_objectid_size
      3
    end
  end
end
