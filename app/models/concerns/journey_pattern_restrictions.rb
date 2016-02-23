module JourneyPatternRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions

    with_options if: :hub_restricted? do |jp|
      # HUB-39
      jp.validate :specific_objectid
      # HUB-40
      jp.validates :registration_number, numericality: { less_than: 10 ** 8 }
      # HUB-41
      #jp.validates_length_of :name, :maximum => 75, :allow_blank => true, :allow_nil => true
      jp.validates :name, length: { maximum: 75 }, allow_blank: true
    end
  end
  def specific_objectid
    validate_specific_objectid( 30)
  end
end
