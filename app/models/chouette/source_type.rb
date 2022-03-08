class Chouette::SourceType < ActiveSupport::StringInquirer

  def initialize(text_code, numerical_code)
    super text_code.to_s
    @numerical_code = numerical_code
  end

  def self.new(text_code, numerical_code = nil)
    if text_code and numerical_code
      super
    elsif self === text_code 
      text_code
    else
      if Integer === text_code
        text_code, numerical_code = definitions.rassoc(text_code)
      else
        text_code, numerical_code = definitions.assoc(text_code.to_s)
      end

      super text_code, numerical_code
    end
  end

  def to_i
    @numerical_code
  end

  def inspect
    "#{to_s}/#{to_i}"
  end

  def name
    camelize
  end

  @@definitions = [
    ["public_and_private_utilities", 0],
    ["road_authorities", 1],
    ["transit_operator", 2],
    ["public_transport", 3],
    ["passenger_transport_coordinating_authority", 4],
    ["travel_information_service_provider", 5],
    ["travel_agency", 6],
    ["individual_subject_of_travel_itinerary", 7],
    ["other_information", 8]
  ]
  cattr_reader :definitions

  @@all = nil
  def self.all
    @@all ||= definitions.collect do |text_code, numerical_code|
      new(text_code, numerical_code)
    end
  end

end
