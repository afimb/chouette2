module JourneyPatternRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions

    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |jp|
      # HUB-40
      jp.validates :registration_number, numericality: { less_than: 10 ** 8 }

      # HUB-41
      jp.validates :name, length: { maximum: 75 }, allow_blank: true
    end

    def self.specific_objectid_size
      30
    end
  end
end
