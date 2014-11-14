collection @time_tables, :object_root => false

node do |time_table|
  { :id => time_table.id, :comment => time_table.comment,
    :time_table_bounding => time_table_bounding( time_table),
    :composition_info => composition_info(time_table),
    :tags => time_table.tags.join(','),
    :day_types => %w(monday tuesday wednesday thursday friday saturday sunday).select{ |d| time_table.send(d) }.map{ |d| time_table.human_attribute_name(d).first(2)}.join('')}
end
