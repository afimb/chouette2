module LineRestrictions
  extend ActiveSupport::Concern

  included do
    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |l|
      # HUB-16
      l.validates :number, length: { in: 1..6 }, format: { with: /\A[\w]+\z/ }

      # HUB-17 & HUB-22
      l.validates :name, length: { maximum: 75 }, uniqueness: true, allow_blank: true

      # HUB-21
      l.validates :registration_number, presence: true, numericality: { less_than: 10 ** 8 }
    end

    def self.specific_objectid_size
      14
    end
  end
end
