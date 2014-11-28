collection @stop_areas

node do |stop_area|
  { :id => stop_area.id, :stop_area_path => @options[ :stop_area_path], :registration_number => stop_area.registration_number || "", :name => stop_area.name || "", :zip_code => stop_area.zip_code || "", :city_name => stop_area.city_name || "" }
end

node :area_type do |area|
  I18n.t("area_types.label.#{area.area_type.underscore}") || ""
end
