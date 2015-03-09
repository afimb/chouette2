class VehicleIdentifier

  def self.auto_identify_vehicles

    #max_identifier = Chouette::VehicleJourney.
    Chouette::VehicleJourney.transaction do
      vehicles = Chouette::VehicleJourney.lock(true).all
      max = vehicles.map(&:vehicle_type_identifier).compact.map(&:to_i).max

      vehicles.select {|v| v.vehicle_type_identifier.nil? }.each_with_index do |v, index|
        v.update_attributes :vehicle_type_identifier => ( max.to_i + index + 1)
      end
    end
  end

end
