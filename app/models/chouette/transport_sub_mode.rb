class Chouette::TransportSubMode < ActiveSupport::StringInquirer

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
      if Fixnum === text_code
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
      ["unknown", 0],

      # Bus sub modes
      ["airport_link_bus", 1],
      ["express_bus", 2],
      ["local_bus", 3],
      ["night_bus", 4],
      ["rail_replacement_bus", 5],
      ["regional_bus", 6],
      ["school_bus", 7],
      ["shuttle_bus", 8],
      ["sightseeing_bus", 9],
      # Tram sub modes

      ["local_tram", 10],

      # Rail sub modes
      ["international", 11],
      ["interregional_rail", 12],
      ["local", 13],
      ["long_distance", 14],
      ["night_rail", 15],
      ["regional_rail", 16],
      ["tourist_railway", 17],

      # Metro sub modes
      ["metro", 18],

      # Air sub modes
      ["domestic_flight", 19],
      ["helicopter_service", 20],
      ["international_flight", 21],

      # Water sub modes
      ["high_speed_passenger_service", 22],
      ["high_speed_vehicle_service", 23],
      ["international_car_ferry", 24],
      ["international_passenger_ferry", 25],
      ["local_car_ferry", 26],
      ["local_passenger_ferry", 27],
      ["national_car_ferry", 28],
      ["sightseeing_service", 29],

      # Cabelway sub modes
      ["telecabin", 30],

      #Funicular sub modes
      ["funicular", 31]
  ]
  cattr_reader :definitions

  @@all = nil
  def self.all
    @@all ||= definitions.collect do |text_code, numerical_code|
      new(text_code, numerical_code)
    end
  end

end
