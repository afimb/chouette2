class IncreaseObjectVersionColumnLength < ActiveRecord::Migration[4.2]
  def up

    change_column :access_links , :object_version , :bigint
    change_column :access_points , :object_version , :bigint
    change_column :brandings , :object_version , :bigint
    change_column :companies , :object_version , :bigint
    change_column :connection_links , :object_version , :bigint
    change_column :dated_service_journeys , :object_version , :bigint
    change_column :dead_run_at_stops , :object_version , :bigint
    change_column :destination_displays , :object_version , :bigint
    change_column :facilities , :object_version , :bigint
    change_column :flexible_service_properties , :object_version , :bigint
    change_column :footnotes , :object_version , :bigint
    change_column :group_of_lines , :object_version , :bigint
    change_column :interchanges , :object_version , :bigint
    change_column :lines , :object_version , :bigint
    change_column :networks , :object_version , :bigint
    change_column :pt_links , :object_version , :bigint
    change_column :route_points , :object_version , :bigint
    change_column :route_sections , :object_version , :bigint
    change_column :routes , :object_version , :bigint
    change_column :scheduled_stop_points , :object_version , :bigint
    change_column :stop_points , :object_version , :bigint
    change_column :time_tables , :object_version , :bigint
    change_column :timebands , :object_version , :bigint
    change_column :vehicle_journey_at_stops , :object_version , :bigint
    change_column :stop_areas , :object_version , :bigint
    change_column :journey_patterns , :object_version , :bigint
    change_column :blocks , :object_version , :bigint
    change_column :dead_runs , :object_version , :bigint
    change_column :vehicle_journeys , :object_version , :bigint

  end

  def down

    change_column :access_links , :object_version , :integer
    change_column :access_points , :object_version , :integer
    change_column :brandings , :object_version , :integer
    change_column :companies , :object_version , :integer
    change_column :connection_links , :object_version , :integer
    change_column :dated_service_journeys , :object_version , :integer
    change_column :dead_run_at_stops , :object_version , :integer
    change_column :destination_displays , :object_version , :integer
    change_column :facilities , :object_version , :integer
    change_column :flexible_service_properties , :object_version , :integer
    change_column :footnotes , :object_version , :integer
    change_column :group_of_lines , :object_version , :integer
    change_column :interchanges , :object_version , :integer
    change_column :lines , :object_version , :integer
    change_column :networks , :object_version , :integer
    change_column :pt_links , :object_version , :integer
    change_column :route_points , :object_version , :integer
    change_column :route_sections , :object_version , :integer
    change_column :routes , :object_version , :integer
    change_column :scheduled_stop_points , :object_version , :integer
    change_column :stop_points , :object_version , :integer
    change_column :time_tables , :object_version , :integer
    change_column :timebands , :object_version , :integer
    change_column :vehicle_journey_at_stops , :object_version , :integer
    change_column :stop_areas , :object_version , :integer
    change_column :journey_patterns , :object_version , :integer
    change_column :blocks , :object_version , :integer
    change_column :dead_runs , :object_version , :integer
    change_column :vehicle_journeys , :object_version , :integer

  end

end
