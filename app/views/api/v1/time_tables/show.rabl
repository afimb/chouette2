object @time_table
extends "api/v1/trident_objects/show"

[ :version, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node(:dates) do |time_table|
  time_table.dates.map(&:date)
end unless root_object.dates.empty?

node(:dates_in) do |time_table|
   time_table.dates.select(&:in_out).map(&:date).sort
end

node(:dates_out) do |time_table|
   time_table.dates.reject(&:in_out).map(&:date).sort
end 

unless root_object.periods.empty?
  attributes :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  child :periods => :periods do |period|
    attributes :period_start, :period_end
  end
end

