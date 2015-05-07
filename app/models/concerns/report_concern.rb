module ReportConcern
  extend ActiveSupport::Concern
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  
  included do    
    attr_reader :datas
  end

  module ClassMethods
  end

  def initialize( response )
    @datas = response.action_report
  end
  
  def current_level
    datas.progression.current_step if datas.progression    
  end

  def last_step
    datas.progression.steps.last if datas.progression
  end

  def current_step_name
    last_step.step if last_step
  end
  
  def current_step
    last_step.realized if last_step
  end

  def total_steps
    last_step.total if last_step
  end

  def zip_file
    datas.zip_file
  end

  def files
    datas.files || []
  end
  
  def error_files
    files.select{ |file| file[:status] == "ERROR"}
  end

  def ignored_files
    files.select{ |file| file[:status] == "IGNORED"}
  end

  def ok_files
    files.select{ |file| file[:status] == "OK"}
  end 
  
  def line_items
    [].tap do |line_items|
      datas.lines.each do |line|
        line_items << LineItem.new(line)
      end if datas.lines?
    end
  end

  def stats
    datas.stats 
  end
  
  def lines
    stats.present? ? stats.line_count : 0
  end
  
  def routes
    stats.present? ? stats.route_count : 0
  end
  
  def connection_links
    stats.present? ? stats.connection_link_count : 0
  end
  
  def time_tables
    stats.present? ? stats.time_table_count : 0
  end
  
  def stop_areas
    stats.present? ? stats.stop_area_count : 0
  end
  
  def access_points
    stats.present? ? stats.access_point_count : 0
  end
  
  def vehicle_journeys
    stats.present? ? stats.vehicle_journey_count : 0
  end
  
  def journey_patterns
    stats.present? ? stats.journey_pattern_count : 0
  end
  
  
  class LineItem
    attr_reader :name, :status, :stats
    
    def initialize( options )
      @name = options.name if options.name?
      @status = options.status if options.status?
      @stats = options.stats if options.stats?
    end
    
    def routes
      stats ? stats.route_count : 0
    end

    def connection_links
      stats ? stats.connection_link_count : 0
    end

    def time_tables
      stats ? stats.time_table_count : 0
    end

    def stop_areas
      stats ? stats.stop_area_count : 0
    end

    def access_points
      stats ? stats.access_point_count : 0
    end
    
    def vehicle_journeys
      stats ? stats.vehicle_journey_count : 0
    end

    def journey_patterns
      stats ? stats.journey_pattern_count : 0
    end

  end 
  
end
