module NetworkRestrictions
  extend ActiveSupport::Concern

  included do
    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |n|
      # HUB-4
      n.validates :name, length: { in: 1..75 }

      # HUB-5
      n.validates :registration_number,
                  uniqueness: true,
                  numericality: { only_integer: true },
                  length: { in: 1..8 }
    end

    def self.specific_objectid_size
      3
    end
  end
end
