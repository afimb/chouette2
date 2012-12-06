object @time_table
extends "api/v1/trident_objects/show"

attributes :version, :comment
attributes :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday

child :dates => :dates do |date|
  attributes :date, :position
end

child :periods => :periods do |period|
  attributes :period_start, :period_end
end

