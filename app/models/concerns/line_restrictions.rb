module LineRestrictions
  extend ActiveSupport::Concern


  included do
    include ObjectidRestrictions

    with_options if: :hub_restricted? do |l|
      # HUB-15
      #l.validates_format_of :objectid, :with => %r{\A\w+:\w+:[\w]{1,14}\z}
      l.validate :specific_objectid
      # HUB-16
      #l.validates_format_of :number, :with => %r{\A[\w]{1,6}\z}
      l.validates :number, length: { in: 1..6 }, format: { with: /\A[\w]+\z/ }
      # HUB-17 & HUB-22
      #l.validates_length_of :name, :maximum => 75
      l.validates :name, length: { maximum: 75 }, uniqueness: true, allow_blank: true
      # HUB-21
      #l.validates :registration_number, :numericality => { :less_than => 10 ** 8 }
      l.validates :registration_number, presence: true, numericality: { less_than: 10 ** 8 }
      # HUB-22
      #l.validates_uniqueness_of :name, :allow_blank => true
    end
  end

  def specific_objectid
    validate_specific_objectid( 14)
  end
end
