class RouteSectionsSelector
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  include ActiveModel::Validations

  attr_reader :itinerary

  def initialize(journey_pattern, attributes = {})
    @itinerary = journey_pattern

    self.attributes = attributes
  end

  def attributes=(attributes)
    attributes.each { |k,v| send "#{k}=", v }
  end

  def update_attributes(attributes)
    self.attributes = attributes
    save
  end

  delegate :stop_points, to: :itinerary

  def sections
    @sections ||= create_sections
  end

  def create_sections
    [].tap do |sections|
      stop_points.each_cons(2).each_with_index do |(from_scheduled_stop_point, to_scheduled_stop_point), index|
        journey_pattern_section = Chouette::JourneyPatternSection.find_by(journey_pattern: @itinerary, rank: index)

        if journey_pattern_section
          route_section = journey_pattern_section ? journey_pattern_section.route_section : nil
        else
          route_section = Chouette::RouteSection.find_by(from_scheduled_stop_point: from_scheduled_stop_point.stop_area, to_scheduled_stop_point: to_scheduled_stop_point.stop_area)
        end

        sections << Section.new(from_scheduled_stop_point.stop_area, to_scheduled_stop_point.stop_area, index, route_section)
      end
    end
  end

  def sections_attributes=(attributes)
    # Process the attributes hash
    attributes.each do |index, section_attributes|
      sections[index.to_i].attributes = section_attributes
    end
  end

  def save
    sections.each do |s|
      Chouette::JourneyPatternSection.update_by_journey_pattern_rank(itinerary.id, s.route_section_id, s.rank)
    end
  end

  class Section
    extend ActiveModel::Translation

    attr_accessor :from_scheduled_stop_point, :to_scheduled_stop_point, :rank, :route_section_id

    def initialize(from_scheduled_stop_point, to_scheduled_stop_point, rank, route_section = nil)
      @from_scheduled_stop_point, @to_scheduled_stop_point, @rank = from_scheduled_stop_point, to_scheduled_stop_point, rank

      self.route_section = route_section
    end

    def route_section=(route_section)
      @route_section = route_section
      @route_section_id = route_section.respond_to?(:id) ? route_section.id : nil
    end

    def route_section
      @route_section ||= candidates.find_by id: route_section_id
    end

    def persisted?
      false
    end

    def candidates
      @candidates ||= Chouette::RouteSection.where(from_scheduled_stop_point: from_scheduled_stop_point, to_scheduled_stop_point: to_scheduled_stop_point)
    end

    def create_candidate
      Chouette::RouteSection.create(from_scheduled_stop_point: from_scheduled_stop_point, to_scheduled_stop_point: to_scheduled_stop_point)
    end

    def attributes=(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def valid?
      route_section.present?
    end

  end

end
