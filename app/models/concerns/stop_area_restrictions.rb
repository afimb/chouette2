module StopAreaRestrictions
  extend ActiveSupport::Concern

  def physical?
    self.area_type=="BoardingPosition" ||  self.area_type=="Quay"
  end
  def commercial?
    self.area_type=="CommercialStopPoint"
  end
  def physical_hub_restricted?
    format_restricted?(:hub) && physical?
  end
  def commercial_hub_restricted?
    format_restricted?(:hub) && commercial?
  end
  def commercial_and_physical_hub_restricted?
    physical_hub_restricted? || commercial_hub_restricted?
  end

  included do
    with_options if: :commercial_and_physical_hub_restricted? do |sa|
      sa.validates :name, length: { in: 1..75 }
    end

    with_options if: :commercial_hub_restricted? do |sa|
      # HUB-24
      sa.validates :nearest_topic_name, length: { maximum: 255 }, allow_blank: true
    end

    with_options if: :physical_hub_restricted? do |sa|
      # HUB-25
      sa.validates :nearest_topic_name, length: { maximum: 60 }, allow_blank: true

      # HUB-28
      sa.validates :coordinates, presence: true

      # HUB-29
      sa.validates :city_name, length: { in: 1..80 }

      # HUB-30
      sa.validates :country_code, presence: true, numericality: { only_integer: true }, length: { is: 5 }

      # HUB-31
      sa.validates :comment, length: { maximum: 255 }, allow_blank: true
      sa.validates :registration_number, presence: true, numericality: { less_than: 10 ** 8 }
    end

    def self.specific_objectid_size
      12
    end
  end
end
