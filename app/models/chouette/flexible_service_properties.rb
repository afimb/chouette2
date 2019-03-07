class Chouette::FlexibleServiceProperties < Chouette::ActiveRecord
  belongs_to :booking_arrangement, :class_name => 'Chouette::BookingArrangement', :dependent => :destroy
  accepts_nested_attributes_for :booking_arrangement, :allow_destroy => :true

  has_one :vehicle_journey, :class_name => 'Chouette::VehicleJourney'

  validates :objectid, presence: true

  before_validation :set_nils

  def set_nils
    self.flexible_service_type = nil if self.flexible_service_type.blank?
  end

  before_destroy :clear_vj_relation
  def clear_vj_relation
    if !self.vehicle_journey.nil?
      self.vehicle_journey.flexible_service_properties=nil
      self.vehicle_journey.save
    end
  end

end
