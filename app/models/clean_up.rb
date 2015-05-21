class CleanUp
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :expected_date, :keep_lines, :keep_stops , :keep_companies
  attr_accessor :keep_networks, :keep_group_of_lines

  validates_presence_of :expected_date

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def vehicle_journeys
    Chouette::VehicleJourney.where "id not in (select distinct vehicle_journey_id from time_tables_vehicle_journeys)"
  end

  def journey_patterns
    Chouette::JourneyPattern.where "id not in (select distinct journey_pattern_id from vehicle_journeys)"
  end

  def routes
    Chouette::Route.where "id not in (select distinct route_id from journey_patterns)"
  end

  def lines
    Chouette::Line.where "id not in (select distinct line_id from routes)"
  end

  def physical_stop_areas
    Chouette::StopArea.physical
  end

  def commercial_stop_areas
    Chouette::StopArea.commercial
  end

  def stop_place_stop_areas
    Chouette::StopArea.stop_place
  end

  def itl_stop_areas
    Chouette::StopArea.itl
  end

  def clean
    # as foreign keys are presents , delete method can be used for faster performance
    result = CleanUpResult.new
    # find and remove time_tables
    tms = Chouette::TimeTable.validity_out_from_on?(Date.parse(expected_date))
    result.time_table_count = tms.size
    tms.each do |tm|
      tm.delete
    end
    # remove vehiclejourneys without timetables
    vehicle_journeys.find_each do |vj|
      if vj.time_tables.size == 0
        result.vehicle_journey_count += 1
        vj.delete
      end
    end
    # remove journeypatterns without vehicle journeys
    journey_patterns.find_each do |jp|
      if jp.vehicle_journeys.size == 0
        result.journey_pattern_count += 1
        jp.delete
      end
    end
    # remove routes without journeypatterns
    routes.find_each do |r|
      if r.journey_patterns.size == 0
        result.route_count += 1
        r.delete
      end
    end
    # if asked remove lines without routes
    if keep_lines == "0"
      lines.find_each do |l|
        if l.routes.size == 0
          result.line_count += 1
          l.delete
        end
      end
    end
    # if asked remove stops without children (recurse)
    if keep_stops == "0"
      physical_stop_areas.find_each do |bp|
        if bp.stop_points.size == 0
          result.stop_count += 1
          bp.delete
        end
      end
      commercial_stop_areas.find_each do |csp|
        if csp.children.size == 0
          result.stop_count += 1
          csp.delete
        end
      end
      stop_place_stop_areas.find_each do |sp|
        if sp.children.size == 0
          result.stop_count += 1
          sp.delete
        end
      end
      itl_stop_areas.find_each do |itl|
        if itl.routing_stops.size == 0
          result.stop_count += 1
          itl.delete
        end
      end
    end
    # if asked remove companies without lines or vehicle journeys
    if keep_companies == "0"
      Chouette::Company.find_each do |c|
        if c.lines.size == 0
          result.company_count += 1
          c.delete
        end
      end
    end

    # if asked remove networks without lines
    if keep_networks == "0"
      Chouette::Network.find_each do |n|
        if n.lines.size == 0
          result.network_count += 1
          n.delete
        end
      end
    end

    # if asked remove group_of_lines without lines
    if keep_group_of_lines == "0"
      Chouette::GroupOfLine.find_each do |n|
        if n.lines.size == 0
          result.group_of_line_count += 1
          n.delete
        end
      end
    end
    result
  end

end
