class Chouette::TransportMode < ActiveSupport::StringInquirer

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
    ["unknown",-2],
    ["interchange",-1],
    ["air",0],
    ["bus",1],
    ["coach",2],
    ["ferry",3],
    ["metro",4],
    ["rail",5],
    ["trolley_bus",6],
    ["tram",7],
    ["water",8],
    ["cableway",9],
    ["funicular",10],
    ["lift",11],
    ["taxi",12],
    ["bicycle",13],
    ["walk",14],
    ["private_vehicle",15],
    ["other",16]

  ]
  cattr_reader :definitions

  @@all = nil
  def self.all
    @@all ||= definitions.collect do |text_code, numerical_code|
      new(text_code, numerical_code)
    end
  end

  def public_transport?
    not interchange?
  end

end
