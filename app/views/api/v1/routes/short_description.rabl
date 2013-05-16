object @route
extends "api/v1/trident_objects/short_description"

[ :name, :published_name, :number, :direction, :wayback].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

