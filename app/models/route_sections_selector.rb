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

  # def persisted?
  #   false
  # end

  delegate :stop_points, to: :itinerary

  def route_sections
    @route_sections ||= itinerary.route_sections.to_a
  end

  def sections
    @sections ||= create_sections
  end

  def create_sections
    [].tap do |sections|
      stop_points.each_cons(2).each_with_index do |(departure, arrival), index|
        sections << Section.new(departure.stop_area, arrival.stop_area, route_sections[index])
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
    itinerary.update_attribute :route_section_ids, sections.map(&:route_section_id)
  end

  class Section
    extend ActiveModel::Translation

    attr_accessor :departure, :arrival, :route_section_id

    def initialize(departure, arrival, route_section = nil)
      @departure, @arrival = departure, arrival

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
