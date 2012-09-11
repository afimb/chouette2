module TimeTablesHelper
  def time_table_state_code(time_table)
    if time_table.validity_out_from_on?(Date.today)
      "validity_out"
    elsif time_table.validity_out_between?(Date.today,Date.today+7.day)
      "validity_out_soon"
    else
      "validity_regular"
    end
  end
  def bounding_info(time_table)
    return t('time_tables.time_table.empty') if time_table.bounding_dates.empty?
    t('time_tables.time_table.bounding', 
        :start => l(time_table.bounding_dates.min),
        :end => l(time_table.bounding_dates.max))
  end
  def bounding_short_info(dates)
    return t('time_tables.time_table.empty') if dates.empty?
    "#{l(dates.min)} #{l(dates.max)}"
  end
  def time_table_bounding( time_table)
    bounding_short_info( time_table.bounding_dates)
  end
  def time_tables_shortest_info( vehicle)
    bounding_short_info( vehicle.bounding_dates)
  end
  def time_tables_info( vehicle)
    vehicle.time_tables.map do |time_table|
      "#{time_table_bounding( time_table)} - #{composition_info(time_table)}"
    end.join( "\n")
  end

  def composition_info(time_table)
    return if time_table.bounding_dates.empty?
    if time_table.dates.empty?
      t('time_tables.time_table.periods_count', :count => time_table.periods.count)
    elsif time_table.periods.empty?
      t('time_tables.time_table.dates_count', :count => time_table.dates.count)
    else
      t('time_tables.time_table.periods_dates_count', 
        :dates_count => time_table.dates.count,
        :periods_count => time_table.periods.count)
    end
  end
end

