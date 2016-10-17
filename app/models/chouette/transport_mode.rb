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
    ["interchange", -1],
    ["unknown", 0],
    ["coach", 1],
    ["air", 2],
    ["waterborne", 3],
    ["bus", 4],
    ["ferry", 5],
    ["walk", 6],
    ["metro", 7],
    ["shuttle", 8],
    ["rapid_transit", 9],
    ["taxi", 10],
    ["local_train", 11],
    ["train", 12],
    ["long_distance_train", 13],
    ["tramway", 14],
    ["trolleybus", 15],
    ["private_vehicle", 16],
    ["bicycle", 17],
    ["other", 18]
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
