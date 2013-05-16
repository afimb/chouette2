object @company
extends "api/v1/trident_objects/show"

[ :name, :short_name, :organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :registration_number].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
