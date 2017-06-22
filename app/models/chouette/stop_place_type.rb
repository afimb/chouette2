class Chouette::StopPlaceType < ActiveSupport::StringInquirer

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
    #["bus", 1],
    #["tram", 2],
    #["rail", 3],
    #["metro", 4],
    #["water", 5],
    #["cabelway", 6],
    #["funicular", 7],
    ["onstreet_bus", 1],
    ["onstreet_tram", 2],
    ["airport", 3],
    ["rail_station", 4],
    ["metro_station",5],
    ["bus_station", 6],
    ["coach_station", 7],
    ["tram_station", 8],
    ["harbour_port", 9],
    ["ferry_port", 10],
    ["ferry_stop", 11],
    ["lift_station", 12],
    ["vehicle_rail_interchange", 13],
    ["other", 14],
  ]
  cattr_reader :definitions

  @@all = nil
  def self.all
    @@all ||= definitions.collect do |text_code, numerical_code|
      new(text_code, numerical_code)
    end
  end

end
