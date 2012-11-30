object @line
attributes :objectid, :creation_time, :creator_id, :name, :number, :published_name, :transport_mode_name
attributes :registration_number, :comment, :mobility_restricted_suitability, :int_user_needs

child :network do
  attributes :id, :name
  node(:aa) { |network| titi }
  node(:url) { |network| api_v1_network_url(:id => network.objectid) }
end

