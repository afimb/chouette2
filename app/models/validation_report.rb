class ValidationReport
  extend ActiveModel::Naming
  include ActiveModel::Model
  
  attr_reader :datas
  
  def initialize( response )
    @datas = response[:action_report]
  end

  def zip_file
    datas.zip_file
  end

  def error_files
    datas.files.select{ |file| file[:status] == "ERROR"}
  end

  def ignored_files
    datas.files.select{ |file| file[:status] == "IGNORED"}
  end

  def ok_files
    datas.files.select{ |file| file[:status] == "OK"}
  end
  
  def files
    datas.files
  end

  def line_items
    [].tap do |line_items|
      datas.lines.each do |line|
        line_items << LineItem.new(line)
      end
    end
  end

  def lines
    datas.stats.line_count if datas.stats.line_count?
  end
  
  def routes
    datas.stats.route_count if datas.stats.route_count?
  end
  
  def connection_links
    datas.stats.connection_link_count if datas.stats.connection_link_count?
  end
  
  def time_tables
    datas.stats.time_table_count if datas.stats.time_table_count?
  end
  
  def stop_areas
    datas.stats.stop_area_count if datas.stats.stop_area_count?
  end
  
  def access_points
    datas.stats.access_point_count if datas.stats.access_point_count?
  end
  
  def vehicle_journeys
    datas.stats.vehicle_journey_count if datas.stats.vehicle_journey_count?
  end
  
  def journey_patterns
    datas.stats.journey_pattern_count if datas.stats.journey_pattern_count?
  end
  
  class LineItem
    attr_reader :name, :status, :stats
    
    def initialize( options = Hashie::Mash.new )
      @name = options.name if options.name?
      @status = options.status if options.status?
      @stats = options.stats if options.stats?
    end
    
    def routes
      stats.route_count
    end

    def connection_links
      stats.connection_link_count
    end

    def time_tables
      stats.time_table_count
    end

    def stop_areas
      stats.stop_area_count
    end

    def access_points
      stats.access_point_count
    end
    
    def vehicle_journeys
      stats.vehicle_journey_count
    end

    def journey_patterns
      stats.journey_pattern_count
    end

  end
  
end

