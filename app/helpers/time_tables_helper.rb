module TimeTablesHelper
  def bounding_info(time_table)
    return t('time_tables.time_table.empty') if time_table.bounding_dates.empty?
    t('time_tables.time_table.bounding', 
        :start => l(time_table.bounding_dates.min),
        :end => l(time_table.bounding_dates.max))
  end
  def time_tables_shortest_info( vehicle)
    return vehicle.bounding_dates.inspect
    #"#{l(vehicle.bounding_dates.min)} #{l(vehicle.bounding_dates.max)}"
  end
  def time_tables_info( vehicle)
    vehicle.time_tables.map do |time_table|
      composition_info(time_table)
    end.join( "\n")
  end

  def composition_info(time_table)
    return if time_table.bounding_dates.empty?
    if time_table.dates.empty?
      t('time_tables.time_table.periods_count', :count => time_table.periods.count)
    elsif
      t('time_tables.time_table.dates_count', :count => time_table.dates.count)
    else
      t('time_tables.time_table.periods_dates_count', 
        :dates_count => time_table.dates.count,
        :periods_count => time_table.periods.count)
    end
  end
end

