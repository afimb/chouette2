class VehicleJourneysFrequenciesController < VehicleJourneysController

  defaults :resource_class => Chouette::VehicleJourney, :collection_name => 'vehicle_journeys', :instance_name => 'vehicle_journey'

  def new
    new! do
      resource.frequencies.build
    end
  end

  protected

  def build_resource
    set_frequency(super)
  end

  def resource
    set_frequency(super)
  end

  private

  def set_frequency(s)
    s.tap do |vehicle_journey|
      vehicle_journey.is_frequency = true
    end
  end

end

