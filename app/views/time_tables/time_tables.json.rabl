collection @time_tables, :object_root => false

node do |time_table|
  { :id => time_table.id, :comment => time_table.comment, :time_table_bounding => time_table_bounding( time_table), :composition_info => composition_info(time_table) }
end                     
