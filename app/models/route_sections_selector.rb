class RouteSectionsSelector
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  include ActiveModel::Validations

  attr_reader :itinerary

  def initialize(route_or_journey_pattern, attributes = {})
    @itinerary = route_or_journey_pattern

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
      stop_points.each_cons(2).each_with_index do |(departure, arrival), index|
        journey_pattern_section = Chouette::JourneyPatternSection.find_by(journey_pattern: @itinerary, rank: index)
        route_section = journey_pattern_section ? journey_pattern_section.route_section : nil
        sections << Section.new(departure.stop_area, arrival.stop_area, route_section, index)
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

    attr_accessor :departure, :arrival, :rank, :route_section_id

    def initialize(departure, arrival, route_section = nil, rank = nil)
      @departure, @arrival, @rank = departure, arrival, rank

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
      @candidates ||= Chouette::RouteSection.where(departure: departure, arrival: arrival)
    end

    def create_candidate
      Chouette::RouteSection.create(departure: departure, arrival: arrival)
    end

    def attributes=(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def valid?
      route_section.present?
    end

  end

end
