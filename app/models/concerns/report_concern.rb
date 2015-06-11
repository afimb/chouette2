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

  delegate :progression?, to: :datas
  delegate :progression, to: :datas
  delegate :zip_file, to: :datas
  delegate :stats, to: :datas

  def failure_code?
    datas.result == "NOK" && datas.failure?
  end

  def failure_code
    datas.failure.code.downcase if failure_code?
  end

  def percentage(a, b)
    (a.to_f / b.to_f * 100).round(0)
  end

  def level_progress
    percentage( progression.current_step, progression.steps_count) if progression?
  end

  def last_step
    datas.progression.steps.last if progression?
  end

  def current_step
    datas.progression.steps[ progression.current_step - 1]
  end

  def step_progress
    percentage( current_step.realized, current_step.total )
  end

  def step_progress_name
    return last_step.step  if progression.current_step == progression.steps_count

    current_step.step
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
    attr_reader :options

    def initialize( options )
      @options = options
    end

    def name
      @name ||= options.name if options.name?
    end

    def stats
      @stats ||= options.stats if options.stats?
    end

    def status
      @status ||= if options.status?
                    if %w{ok warning}.include? options.status.downcase
                      true
                    else
                      false
                    end
                  else
                    false
                  end
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
