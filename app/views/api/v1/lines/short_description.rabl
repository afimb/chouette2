object @line
extends "api/v1/trident_objects/short_description"

[ :name, :published_name, :number, :registration_number].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
