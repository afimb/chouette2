object @line
attributes :objectid, :object_version, :creation_time, :creator_id
attributes :name, :number, :published_name, :transport_mode_name
attributes :registration_number, :comment, :mobility_restricted_suitability, :int_user_needs

child :network do
  attributes :objectid, :name, :description, :registration_number
end

child :company do
  attributes :objectid, :name, :short_name, :registration_number
end
