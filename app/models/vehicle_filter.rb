class VehicleFilter
  attr_accessor :route
  attr_accessor :q
  attr_accessor :journey_category_model

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if self.respond_to? name.to_sym
    end
  end

  def without_any_time_table?
    q && q[ "time_tables_id_not_eq" ] && q[ "time_tables_id_not_eq" ]=="1"
  end
  def without_any_passing_time?
    q && q[ "vehicle_journey_at_stops_departure_time_not_eq" ] &&
      q[ "vehicle_journey_at_stops_departure_time_not_eq" ]=="1"
  end
  def vehicles_passing_time_filtered
    if without_any_passing_time?
      route.send(journey_category_model).without_any_passing_time
    else
      route.sorted_vehicle_journeys(journey_category_model)
    end
  end
  def vehicle_journeys
    if without_any_time_table?
      vehicles_passing_time_filtered.without_any_time_table
    elsif time_table_ids.empty?
      vehicles_passing_time_filtered
    else
      vehicles_passing_time_filtered.joins(:time_tables).where("time_tables_vehicle_journeys.time_table_id" => time_table_ids)
    end
  end
  def time_table_ids
    return [] unless q && q[ "time_tables_id_eq" ]
    q[ "time_tables_id_eq" ].split(',')
  end
  def filtered_params
    return {} unless q
    q.tap do |filtered_params|
      if without_any_passing_time?
        1.upto( 5 ) do |index|
          q.delete "vehicle_journey_at_stops_departure_time_gt(#{index}i)"
        end
      end
      q.delete "time_tables_id_eq"
      q.delete "time_tables_id_not_eq"
      q.delete "vehicle_journey_at_stops_departure_time_not_eq"
    end
  end


end
