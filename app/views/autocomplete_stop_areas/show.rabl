object @stop_area

node do |stop_area|
  {
  :id => stop_area.id,
  :registration_number => stop_area.registration_number || "",
  :short_registration_number => truncate(stop_area.registration_number, :length => 10) || "",
  :name => stop_area.name || "",
  :short_name => truncate(stop_area.name, :length => 30) || "",
  :zip_code => stop_area.zip_code || "",
  :city_name => stop_area.city_name || "",
  :short_city_name => truncate(stop_area.city_name, :length => 15) || ""
  }
end

node(:stop_area_path) { |stop_area|
  stop_area_picture_url(stop_area) || ""
}
