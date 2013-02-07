# This migration comes from ninoxe_engine (originally 20130204141720)
require "forwardable"

class AddForeignKeys < ActiveRecord::Migration
  def up
    # t.remove_foreign_key does not works if foreign key doesn't exists so check before if keys already exists
    change_table :access_links do |t|
      if  @connection.foreign_keys(:access_links).any? 
  @connection.foreign_keys(:access_links).map do |f|
    name = f.options[:name]
    if (name == "aclk_acpt_fkey" || name == "aclk_area_fkey" )
       remove_foreign_key :access_links, :name => name
    end
  end
      end
      t.foreign_key :access_points, :dependent => :delete, :name => 'aclk_acpt_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :name => 'aclk_area_fkey'
    end
    change_table :access_points do |t|
      if  @connection.foreign_keys(:access_points).any? 
  @connection.foreign_keys(:access_points).map do |f|
    name = f.options[:name]
    if (name == "access_area_fkey" )
       remove_foreign_key :access_points, :name => name
    end
  end
      end
      t.foreign_key :stop_areas, :dependent => :delete, :name => 'access_area_fkey'
    end
    change_table :connection_links do |t|
      if  @connection.foreign_keys(:connection_links).any? 
  @connection.foreign_keys(:connection_links).map do |f|
    name = f.options[:name]
    if (name == "colk_endarea_fkey" || name == "colk_startarea_fkey" )
       remove_foreign_key :connection_links, :name => name
    end
  end
      end
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'arrival_id', :name => 'colk_endarea_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'departure_id', :name => 'colk_startarea_fkey'
    end
    change_table :group_of_lines_lines do |t|
      if  @connection.foreign_keys(:group_of_lines_lines).any? 
  @connection.foreign_keys(:group_of_lines_lines).map do |f|
    name = f.options[:name]
    if (name == "groupofline_group_fkey" || name == "groupofline_line_fkey" )
       remove_foreign_key :group_of_lines_lines, :name => name
    end
  end
      end
      t.foreign_key :group_of_lines, :dependent => :delete, :name => 'groupofline_group_fkey'
      t.foreign_key :lines, :dependent => :delete,  :name => 'groupofline_line_fkey'
    end
    change_table :journey_patterns do |t|
      if  @connection.foreign_keys(:journey_patterns).any? 
  @connection.foreign_keys(:journey_patterns).map do |f|
    name = f.options[:name]
    if (name == "arrival_point_fkey" || name == "departure_point_fkey"  || name == "jp_route_fkey")
       remove_foreign_key :journey_patterns, :name => name
    end
  end
      end
      t.foreign_key :stop_points, :dependent => :nullify, :column => 'arrival_stop_point_id', :name => 'arrival_point_fkey'
      t.foreign_key :stop_points, :dependent => :nullify, :column => 'departure_stop_point_id', :name => 'departure_point_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'jp_route_fkey'
    end
    change_table :journey_patterns_stop_points do |t|
      if  @connection.foreign_keys(:journey_patterns_stop_points).any? 
  @connection.foreign_keys(:journey_patterns_stop_points).map do |f|
    name = f.options[:name]
    if (name == "jpsp_jp_fkey" || name == "jpsp_stoppoint_fkey" )
       remove_foreign_key :journey_patterns_stop_points, :name => name
    end
  end
      end
      t.foreign_key :journey_patterns, :dependent => :delete, :name => 'jpsp_jp_fkey'
      t.foreign_key :stop_points, :dependent => :delete,  :name => 'jpsp_stoppoint_fkey'
    end
    change_table :lines do |t|
      if  @connection.foreign_keys(:lines).any? 
  @connection.foreign_keys(:lines).map do |f|
    name = f.options[:name]
    if (name == "line_company_fkey" || name == "line_ptnetwork_fkey" )
       remove_foreign_key :lines, :name => name
    end
  end
      end
      t.foreign_key :companies, :dependent => :nullify, :name => 'line_company_fkey'
      t.foreign_key :networks, :dependent => :nullify,  :name => 'line_ptnetwork_fkey'
    end
    change_table :routes do |t|
      if  @connection.foreign_keys(:routes).any? 
  @connection.foreign_keys(:routes).map do |f|
    name = f.options[:name]
    if (name == "route_line_fkey" )
       remove_foreign_key :routes, :name => name
    end
  end
      end
      t.foreign_key :lines, :dependent => :delete, :name => 'route_line_fkey'
    end
    change_table :routing_constraints_lines do |t|
      if  @connection.foreign_keys(:routing_constraints_lines).any? 
  @connection.foreign_keys(:routing_constraints_lines).map do |f|
    name = f.options[:name]
    if (name == "routingconstraint_line_fkey" || name == "routingconstraint_stoparea_fkey" )
       remove_foreign_key :routing_constraints_lines, :name => name
    end
  end
      end
      t.foreign_key :lines, :dependent => :delete, :name => 'routingconstraint_line_fkey'
      t.foreign_key :stop_areas, :dependent => :delete,  :name => 'routingconstraint_stoparea_fkey'
    end
    change_table :stop_areas do |t|
      if  @connection.foreign_keys(:stop_areas).any? 
  @connection.foreign_keys(:stop_areas).map do |f|
    name = f.options[:name]
    if (name == "area_parent_fkey" )
       remove_foreign_key :stop_areas, :name => name
    end
  end
      end
      t.foreign_key :stop_areas, :dependent => :nullify, :column => 'parent_id', :name => 'area_parent_fkey'
    end
    change_table :stop_areas_stop_areas do |t|
      if  @connection.foreign_keys(:stop_areas_stop_areas).any? 
  @connection.foreign_keys(:stop_areas_stop_areas).map do |f|
    name = f.options[:name]
    if (name == "stoparea_child_fkey" || name == "stoparea_parent_fkey" )
       remove_foreign_key :stop_areas_stop_areas, :name => name
    end
  end
      end
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'child_id', :name => 'stoparea_child_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'parent_id', :name => 'stoparea_parent_fkey'
    end
    change_table :stop_points do |t|
      if  @connection.foreign_keys(:stop_points).any? 
  @connection.foreign_keys(:stop_points).map do |f|
    name = f.options[:name]
    if (name == "stoppoint_area_fkey" || name == "stoppoint_route_fkey" )
       remove_foreign_key :stop_points, :name => name
    end
  end
      end
      t.foreign_key :stop_areas, :name => 'stoppoint_area_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'stoppoint_route_fkey'
    end
    change_table :time_table_dates do |t|
      if  @connection.foreign_keys(:time_table_dates).any? 
  @connection.foreign_keys(:time_table_dates).map do |f|
    name = f.options[:name]
    if (name == "tm_date_fkey" )
       remove_foreign_key :time_table_dates, :name => name
    end
  end
      end
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'tm_date_fkey'
    end
    change_table :time_table_periods do |t|
      if  @connection.foreign_keys(:time_table_periods).any? 
  @connection.foreign_keys(:time_table_periods).map do |f|
    name = f.options[:name]
    if (name == "tm_period_fkey"  )
       remove_foreign_key :time_table_periods, :name => name
    end
  end
      end
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'tm_period_fkey'
    end
    change_table :time_tables_vehicle_journeys do |t|
      if  @connection.foreign_keys(:time_tables_vehicle_journeys).any? 
  @connection.foreign_keys(:time_tables_vehicle_journeys).map do |f|
    name = f.options[:name]
    if (name == "vjtm_tm_fkey" || name == "vjtm_vj_fkey" )
       remove_foreign_key :time_tables_vehicle_journeys, :name => name
    end
  end
      end
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'vjtm_tm_fkey'
      t.foreign_key :vehicle_journeys, :dependent => :delete,  :name => 'vjtm_vj_fkey'
    end
    change_table :vehicle_journey_at_stops do |t|
      if  @connection.foreign_keys(:vehicle_journey_at_stops).any? 
  @connection.foreign_keys(:vehicle_journey_at_stops).map do |f|
    name = f.options[:name]
    if (name == "vjas_sp_fkey" || name == "vjas_vj_fkey" )
       remove_foreign_key :vehicle_journey_at_stops, :name => name
    end
  end
      end
      t.foreign_key :stop_points, :dependent => :delete,  :name => 'vjas_sp_fkey'
      t.foreign_key :vehicle_journeys, :dependent => :delete,  :name => 'vjas_vj_fkey'
    end
    change_table :vehicle_journeys do |t|
      if  @connection.foreign_keys(:vehicle_journeys).any? 
  @connection.foreign_keys(:vehicle_journeys).map do |f|
    name = f.options[:name]
    if (name == "vj_company_fkey" || name == "vj_jp_fkey"  || name == "vj_route_fkey")
       remove_foreign_key :vehicle_journeys, :name => name
    end
  end
      end
      t.foreign_key :companies, :dependent => :nullify,  :name => 'vj_company_fkey'
      t.foreign_key :journey_patterns, :dependent => :delete,  :name => 'vj_jp_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'vj_route_fkey'
    end
    
  end

  def down
    change_table :access_links do |t|
      t.remove_foreign_key :name => :aclk_acpt_fkey
      t.remove_foreign_key :name => :aclk_area_fkey
    end
    change_table :access_points do |t|
      t.remove_foreign_key :name => :access_area_fkey
    end
    change_table :connection_links do |t|
      t.remove_foreign_key :name => :colk_endarea_fkey
      t.remove_foreign_key :name => :colk_startarea_fkey
    end
    change_table :group_of_lines_lines do |t|
      t.remove_foreign_key :name => :groupofline_group_fkey
      t.remove_foreign_key :name => :groupofline_line_fkey
    end
    change_table :journey_patterns do |t|
      t.remove_foreign_key :name => :arrival_point_fkey
      t.remove_foreign_key :name => :departure_point_fkey
      t.remove_foreign_key :name => :jp_route_fkey
    end
    change_table :journey_patterns_stop_points do |t|
      t.remove_foreign_key :name => :jpsp_jp_fkey
      t.remove_foreign_key :name => :jpsp_stoppoint_fkey
    end
    change_table :lines do |t|
      t.remove_foreign_key :name => :line_company_fkey
      t.remove_foreign_key :name => :line_ptnetwork_fkey
    end
    change_table :routes do |t|
      t.remove_foreign_key :name => :route_line_fkey
    end
    change_table :routing_constraints_lines do |t|
      t.remove_foreign_key :name => :routingconstraint_line_fkey
      t.remove_foreign_key :name => :routingconstraint_stoparea_fkey
    end
    change_table :stop_areas do |t|
      t.remove_foreign_key :name => :area_parent_fkey
    end
    change_table :stop_areas_stop_areas do |t|
      t.remove_foreign_key :name => :stoparea_child_fkey
      t.remove_foreign_key :name => :stoparea_parent_fkey
    end
    change_table :stop_points do |t|
      t.remove_foreign_key :name => :stoppoint_area_fkey
      t.remove_foreign_key :name => :stoppoint_route_fkey
    end
    change_table :time_table_dates do |t|
      t.remove_foreign_key :name => :tm_date_fkey
    end
    change_table :time_table_periods do |t|
      t.remove_foreign_key :name => :tm_period_fkey
    end
    change_table :time_tables_vehicle_journeys do |t|
      t.remove_foreign_key :name => :vjtm_tm_fkey
      t.remove_foreign_key :name => :vjtm_vj_fkey
    end
    change_table :vehicle_journey_at_stops do |t|
      t.remove_foreign_key :name => :vjas_sp_fkey
      t.remove_foreign_key :name => :vjas_vj_fkey
    end
    change_table :vehicle_journeys do |t|
      t.remove_foreign_key :name => :vj_company_fkey
      t.remove_foreign_key :name => :vj_jp_fkey
      t.remove_foreign_key :name => :vj_route_fkey
    end
  end
end
