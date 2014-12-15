class Chouette::Hub::Exporter
  require "zip"
  
  attr_reader :referential
  attr_reader :hub_export, :lines, :routes, :journey_patterns
  attr_reader :time_tables, :vehicle_journeys
  
  def initialize(referential, hub_export)
    @referential = referential
    @hub_export = hub_export
    @lines = nil
    @routes = nil
    @journey_patterns = nil
    @time_tables = nil
    @vehicle_journeys = nil
  end
  
  def select_time_tables(start_date, end_date)
    #TODO considere options[:o], options[:id]
    all_time_tables = Chouette::TimeTable.all 
    time_tables = []
    s_date = Date.strptime(start_date, "%Y-%m-%d")
    e_date = Date.strptime(end_date, "%Y-%m-%d")
    while s_date <= e_date
      (all_time_tables - time_tables).each { |time_table| time_tables << time_table if time_table.include_day?(s_date) }
      s_date = s_date.next_day
    end
    return time_tables
  end
  
  def select_lines(object, ids)
    if object == "network"
      ids.present? ? Chouette::Line.includes(:routes).where( :network_id => ids.split(",")).order(:objectid) :
        Chouette::Line.joins(:network).includes(:routes).order(:objectid)
    elsif object == "company"
      ids.present? ? Chouette::Line.includes(:routes).where( :company_id => ids.split(",")).order(:objectid) :
        Chouette::Line.joins(:company).includes(:routes).order(:objectid)
    elsif object == "line" && ids.present?
      Chouette::Line.includes(:routes).where( :id => ids.split(",")).order(:objectid)
    else
      Chouette::Line.includes(:routes).order(:objectid)
    end
  end
  
  def referential_exportable?
    Chouette::VehicleJourneyAtStop.all.count < 50000
  end

  def time_tables_exportable?
    time_tables
  end
  
  def routes_exportable?
    routes # && routes.size < 150
  end
  
  def lines_exportable?
    lines # && lines.size < 150
  end
  
  def journey_patterns_exportable?
    journey_patterns # && journey_patterns.size < 150
  end
  
  def vehicle_journeys_exportable?
    vehicle_journeys
  end
  
  def log_overflow_warning( target_class)
    hub_export.log_messages.create( :severity => "warning", :key => "EXPORT_ERROR|EXCEPTION",
                                    :arguments => {"0" => I18n.t( 'export_log_messages.messages.overflow',
                                                                  :count => 150, :data => target_class.model_name.human.pluralize)})
  end
  
  def export(zip_file_path, options = {})
    begin
      referential.switch

      if referential_exportable? && options[:start_date] && options[:end_date]
      
        FileUtils.rm(zip_file_path) if File.exists? zip_file_path
      
        hub_export.log_messages.create( :severity => "ok", :key => "EXPORT", :arguments => {"0" => "HUB"})
      
      Dir.mktmpdir(nil, "/tmp"){ |temp_dir|
        
        @time_tables = select_time_tables(options[:start_date], options[:end_date])
        
        @lines = select_lines( options[:o], options[:id] )
        
        @routes = []
        if @lines
          @lines.each { |line| @routes << Chouette::Route.where( "line_id = ?", line.id ).order(:wayback) }
        end
        
        @journey_patterns = []
        if @routes
          @routes.each { |subroutes| @journey_patterns << Chouette::JourneyPattern.where( :route_id => subroutes.map(&:id) ).order(:objectid) }
        end
        @journey_patterns = @journey_patterns.flatten
        
        @routes = @routes.flatten
        @vehicle_journeys = Chouette::VehicleJourney.where(:route_id => @routes.map(&:id)).order(:objectid) if routes_exportable?
        
        rts = []
        jps = []
        vjs = []
        tts = []
        @vehicle_journeys.each do |vj|
          unless (vj.time_tables & @time_tables).empty?
            vjs << vj
            tts << (vj.time_tables & @time_tables)
            rts << vj.route_id
            jps << vj.journey_pattern_id
          end
        end
        @time_tables = tts.flatten.uniq
        @vehicle_journeys = vjs.uniq
        rts = rts.flatten.uniq
        jps = jps.flatten.uniq
        
        @routes.delete_if {|r| !(rts.include?(r.id)) }
        @journey_patterns.delete_if {|jp| !(jps.include?(jp.id)) }
        
        
        vehicle_journey_at_stops = Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => @vehicle_journeys.map(&:id) ) #.order(:id) if vehicle_journeys_exportable?
        
        if time_tables_exportable?
          Chouette::Hub::TimeTableExporter.save(@time_tables, temp_dir, hub_export)
        else
          log_overflow_warning(Chouette::TimeTable)
        end
        
        if journey_patterns_exportable?
          Chouette::Hub::RouteExporter.save(@routes, temp_dir, hub_export)
          Chouette::Hub::ItlExporter.save(@routes, temp_dir, hub_export)
          Chouette::Hub::JourneyPatternExporter.save(@journey_patterns, temp_dir, hub_export)
          Chouette::Hub::DirectionExporter.save(@journey_patterns, temp_dir, hub_export)
        else
          log_overflow_warning(Chouette::JourneyPattern) if routes_exportable?
        end
        
        if vehicle_journeys_exportable?
          Chouette::Hub::VehicleJourneyExporter.save(@vehicle_journeys, temp_dir, hub_export)
          Chouette::Hub::VehicleJourneyOperationExporter.save(@vehicle_journeys, temp_dir, hub_export)
          #Chouette::Hub::VehicleJourneyAtStopExporter.save(vehicle_journey_at_stops, temp_dir, hub_export)
          Chouette::Hub::VehicleJourneyAtStopExporter.save(@vehicle_journeys, temp_dir, hub_export, vehicle_journey_at_stops.count)
        else
          log_overflow_warning(Chouette::VehicleJourney)
        end
        
        stop_points = Chouette::StopPoint.where( :id => vehicle_journey_at_stops.map(&:stop_point_id)) #.order(:id)
        physical_stop_areas =  Chouette::StopArea.where( :id => stop_points.map(&:stop_area_id)) #.order(:parent_id)
        commercial_stop_areas = Chouette::StopArea.where( :id => physical_stop_areas.map(&:parent_id)).order(:objectid)
        
        physical_stop_areas = []
        commercial_stop_areas.each { |commercial_stop_area| physical_stop_areas << Chouette::StopArea.where( :parent_id => [commercial_stop_area.id] ).order(:objectid) }
        physical_stop_areas = physical_stop_areas.flatten

        city_codes = Hash.new
        commercial_stop_areas.each { |commercial_stop_area| city_codes[commercial_stop_area.zip_code] =  commercial_stop_area.city_name if commercial_stop_area.zip_code }
        physical_stop_areas.each { |physical_stop_area| city_codes[physical_stop_area.zip_code] =  physical_stop_area.city_name if physical_stop_area.zip_code }
        
        Chouette::Hub::CityCodeExporter.save(city_codes, temp_dir, hub_export)
        Chouette::Hub::CommercialStopAreaExporter.save(commercial_stop_areas, temp_dir, hub_export)
        Chouette::Hub::PhysicalStopAreaExporter.save(physical_stop_areas, temp_dir, hub_export)

        connection_links = Chouette::ConnectionLink.where( "departure_id IN (?) AND arrival_id IN (?)", (physical_stop_areas.map(&:id) + commercial_stop_areas.map(&:id)), (physical_stop_areas.map(&:id) + commercial_stop_areas.map(&:id)) ).order(:id)
        
        Chouette::Hub::ConnectionLinkExporter.save(connection_links, temp_dir, hub_export)
        
        
        if lines_exportable?
          Chouette::Hub::LineExporter.save(@lines, temp_dir, hub_export)
          
          transport_modes = Hash.new
          @lines.each do |l|
            if l.transport_mode_name
              case l.transport_mode_name
              when "Coach"
                if transport_modes["CAR"]
                  transport_modes["CAR"] += "|"+l.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
                else
                  transport_modes["CAR"] = l.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
                end
              when "Bus"
                if transport_modes["BUS"]
                  transport_modes["BUS"] += "|"+l.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
                else
                  transport_modes["BUS"] = l.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
                end
              end
            end
          end
          Chouette::Hub::TransportModeExporter.save(transport_modes, temp_dir, hub_export)
          networks = Chouette::Network.where( :id => @lines.map(&:network_id))
          companies = Chouette::Company.where( :id => @lines.map(&:company_id))
          groups_of_lines = []
          @lines.each { |l| groups_of_lines << l.group_of_lines }
          groups_of_lines = groups_of_lines.flatten.uniq
          Chouette::Hub::GroupOfLinesExporter.save(groups_of_lines, temp_dir, hub_export)
          Chouette::Hub::NetworkExporter.save(networks, temp_dir, hub_export)
          Chouette::Hub::CompanyExporter.save(companies, temp_dir, hub_export)
        else
          log_overflow_warning(Chouette::Line)
        end
        
        #if routes_exportable?
        #  Chouette::Hub::RouteExporter.save( routes, temp_dir, hub_export)
        #else
        #  log_overflow_warning(Chouette::Route) if lines_exportable?
        #end

        # if too many lines
        # there may be too many stop_areas
        if lines_exportable?
          stop_areas = Chouette::StopArea.joins( :stop_points => [:route => :line]).where(:lines => {:id => lines.map(&:id)}).uniq.order(:name)
          #Chouette::Hub::StopAreaExporter.save( stop_areas, temp_dir, hub_export, "Quay")

          commercial_stop_areas = Chouette::StopArea.where( :id => stop_areas.map(&:parent_id).compact.uniq).order(:name)
          #Chouette::Hub::StopAreaExporter.save( commercial_stop_areas, temp_dir, hub_export, "CommercialStopPoint")
        end

        if( options[:o] == "line" and not options[:id].present?) # Add all objects
          stop_places = referential.stop_areas.stop_place.order(:name)
          #Chouette::Hub::StopAreaExporter.save( stop_places, temp_dir, hub_export, "StopPlace")

          itls = referential.stop_areas.itl.order(:name)
          #Chouette::Hub::StopAreaExporter.save( itls, temp_dir, hub_export, "ITL")

          connection_links = referential.connection_links.order(:name)
          #Chouette::Hub::ConnectionLinkExporter.save( connection_links, temp_dir, hub_export)

          access_links = referential.access_links.order(:name)
          #Chouette::Hub::AccessLinkExporter.save(access_links, temp_dir, hub_export)

          access_points = referential.access_points.order(:name)
          #Chouette::Hub::AccessPointExporter.save(access_points, temp_dir, hub_export)

        end

        ::Zip::File.open(zip_file_path, ::Zip::File::CREATE) do |zipfile|
          Dir[File.join(temp_dir, '*.TXT')].each do |f|
            #Rails.logger.error("Adding File #{File.basename(f)}")
            zipfile.add(File.basename(f), f)
          end
        end
      }
      end
    ensure
      # Always cleanup files
      #FileUtils.remove_entry(temp_directory)
    end
  end

end

