object @access_link
extends "api/v1/trident_objects/short_description"

[ :name, :short_name, :registration_number].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
