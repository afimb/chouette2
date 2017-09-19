collection @scheduled_stop_points

node do |scheduled_stop_point|
  {
  :id => scheduled_stop_point.scheduled_stop_point_id_or_stop_area_objectid_key,
  :name => truncate(scheduled_stop_point.name, :length => 30) || "",
  :stop_point_cnt => scheduled_stop_point.stop_points.size,
  :stop_area_name => scheduled_stop_point.stop_area ?  truncate(scheduled_stop_point.stop_area.name, :length => 30) || "" : "",
  :stop_area_zip_code => scheduled_stop_point.stop_area != nil ? scheduled_stop_point.stop_area.zip_code || "" : "",
  :stop_area_short_city_name =>  scheduled_stop_point.stop_area != nil ? truncate(scheduled_stop_point.stop_area.city_name, :length => 15) || "" : ""
  }
end

node(:stop_area_path) { |scheduled_stop_point|
  scheduled_stop_point.stop_area != nil ? stop_area_picture_url(scheduled_stop_point.stop_area) || "" : ""
}


