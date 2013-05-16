object @network
extends "api/v1/trident_objects/short_description"

[ :name, :description, :registration_number].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
