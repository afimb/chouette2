class IncreaseIdColumnLength < ActiveRecord::Migration[4.2]
  def change

    change_column :footnotes_stop_points, :stop_point_id, :bigint
    change_column :footnotes_stop_points, :footnote_id, :bigint
    change_column :footnotes_vehicle_journey_at_stops, :vehicle_journey_at_stop_id, :bigint
    change_column :footnotes_vehicle_journey_at_stops, :footnote_id, :bigint
    change_column :footnotes_lines, :line_id, :bigint
    change_column :footnotes_lines, :footnote_id, :bigint
    change_column :footnotes_journey_patterns, :journey_pattern_id, :bigint
    change_column :footnotes_journey_patterns, :footnote_id, :bigint

    change_column :api_keys, :referential_id, :bigint

    change_column :booking_arrangements, :booking_contact_id, :bigint
    change_column :booking_arrangements_booking_methods, :booking_arrangement_id, :bigint
    change_column :booking_arrangements_buy_when, :booking_arrangement_id, :bigint
    change_column :companies, :branding_id, :bigint
    change_column :flexible_service_properties, :booking_arrangement_id, :bigint
    change_column :lines, :booking_arrangement_id, :bigint
    change_column :lines_key_values, :line_id, :bigint
    change_column :networks, :company_id, :bigint
    change_column :route_points, :scheduled_stop_point_id, :bigint
    change_column :route_sections, :from_scheduled_stop_point_id, :bigint
    change_column :route_sections, :to_scheduled_stop_point_id, :bigint


    change_column :routes_route_points, :route_id, :bigint
    change_column :routes_route_points, :route_point_id, :bigint
    change_column :stop_points, :destination_display_id, :bigint
    change_column :stop_points, :scheduled_stop_point_id, :bigint
    change_column :stop_points, :booking_arrangement_id, :bigint
    change_column :taggings, :tag_id, :bigint
    change_column :taggings, :taggable_id, :bigint
    change_column :taggings, :tagger_id, :bigint

    change_column :users, :organisation_id, :bigint
    change_column :users, :invited_by_id, :bigint
    change_column :vehicle_journeys, :flexible_service_properties_id, :bigint
    change_column :vehicle_journeys_key_values, :vehicle_journey_id, :bigint

  end
end
