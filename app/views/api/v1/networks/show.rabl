object @network
extends "api/v1/trident_objects/show"

[ :version_date, :description, :name, :registration_number, :source_name,
  :source_type, :source_identifier, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
