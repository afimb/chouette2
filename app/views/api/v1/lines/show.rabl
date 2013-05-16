object @line
extends "api/v1/trident_objects/show"
[ :name, :number, :published_name, :transport_mode_name, :registration_number, :comment, :mobility_restricted_suitability].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node :network_short_description do |line|
  partial("api/v1/networks/short_description", :object => line.network)
end unless root_object.network.nil?

node :company_short_description do |line|
  partial("api/v1/companies/short_description", :object => line.company) 
end  unless root_object.company.nil?

