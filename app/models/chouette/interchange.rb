class Chouette::Interchange < Chouette::TridentActiveRecord

  before_save :default_values

  validates_presence_of :name
  validates_presence_of :from_point
  validates_presence_of :to_point
  validates_presence_of :from_vehicle_journey
  validates_presence_of :to_vehicle_journey
  validates :priority, numericality: { greater_than: 0 }
  validates_numericality_of :from_visit_number, :only_integer => true, :allow_nil => true, greater_than: 0,
    :message => "can only be empty or a positive number."
    validates_numericality_of :to_visit_number, :only_integer => true, :allow_nil => true, greater_than: 0,
    :message => "can only be empty or a positive number."

#TODO trouble with time_select  validates_presence_of :maximum_wait_time
  validates_format_of :from_point, :with => %r{\A([A-Z]{3}):([A-Za-z]*):([0-9A-Za-z_\\-]*)\Z}, :allow_nil => false, :allow_blank => false
  validates_format_of :to_point, :with => %r{\A([A-Z]{3}):([A-Za-z]*):([0-9A-Za-z_\\-]*)\Z}, :allow_nil => false, :allow_blank => false
  validates_format_of :from_vehicle_journey, :with => %r{\A([A-Z]{3}):([A-Za-z]*):([0-9A-Za-z_\\-]*)\Z}, :allow_nil => false, :allow_blank => false
  validates_format_of :to_vehicle_journey, :with => %r{\A([A-Z]{3}):([A-Za-z]*):([0-9A-Za-z_\\-]*)\Z}, :allow_nil => false, :allow_blank => false
  validate :check_not_same_service_journey


  def self.object_id_key
    "ServiceInterchange"
  end

  def check_not_same_service_journey
    errors.add(:from_vehicle_journey, "can't be the same as consumer service journey") if from_vehicle_journey == to_vehicle_journey
  end

  def default_values
    self.priority ||= 1 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

end
