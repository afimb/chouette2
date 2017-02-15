class Chouette::AreaType < ActiveSupport::StringInquirer

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
    if to_s == 'itl'
      to_s.upcase
    else
      camelize
    end
  end

  def self.list_parents(referential_format, text_code)
    text_code = text_code.underscore
    case referential_format
    when :gtfs
      return ['station'] if ['stop'].include? text_code
    when :neptune, :hub, :netex_experimental
      return ['commercial_stop_point'] if ['boarding_position', 'quay'].include? text_code
      return ['stop_place'] if ['commercial_stop_point', 'stop_place'].include? text_code
    when :netex_france
      return ['lieu_d-arret_monomodal'] if ['zone_d_embarquement'].include? text_code
      return ['pole_monomodal', 'lieu_d-arret_multimodal'] if ['lieu_d_arret_monomodal'].include? text_code
      return ['lieu_d-arret_multimodal'] if ['pole_monomodal'].include? text_code
      return ['groupe_de_lieux'] if ['lieu_d_arret_multimodal'].include? text_code
    else
      return []
    end
    return []
  end

  def self.list_children(referential_format, text_code)
    text_code = text_code.underscore
    case referential_format
    when :gtfs
      return ['stop'] if ['station'].include? text_code
    when :neptune, :hub, :netex_experimental
      return ['boarding_position', 'quay'] if ['commercial_stop_point'].include? text_code
      return ['commercial_stop_point', 'stop_place'] if ['stop_place'].include? text_code
    when :netex_france
      return ['zone_d-embarquement'] if ['lieu_d_arret_monomodal'].include? text_code
      return ['lieu_d-arret_monomodal'] if ['pole_monomodal', 'lieu_d_arret_multimodal'].include? text_code
      return ['pole_monomodal'] if ['lieu_d_arret_multimodal'].include? text_code
      return ['lieu_d-arret_multimodal'] if ['groupe_de_lieux'].include? text_code
    else
      return []
    end
    return []
  end

  def self.list_access_points
    [
      'station', 'commercial_stop_point', 'stop_place', 'lieu_d_arret_monomodal', 'lieu_d_arret_multimodal'
    ]
  end

  @@definitions = [
    ["boarding_position", 0],
    ["quay", 1],
    ["commercial_stop_point", 2],
    ["stop_place", 3],
    ["stop", 4],
    ["station", 5],
    ["zone_d_embarquement", 6],
    ["lieu_d_arret_monomodal", 7],
    ["pole_monomodal", 8],
    ["lieu_d_arret_multimodal", 9],
    ["groupe_de_lieux", 10]
  ]
  cattr_reader :definitions

  @@all = nil
  def self.all(referential_format)
    definitions.collect do |text_code, numerical_code|
      next unless area_types_by_format[referential_format].include?(numerical_code)
      new(text_code, numerical_code)
    end.compact
  end

  def self.area_types_by_format
    {
      neptune: [0, 1, 2, 3],
      hub: [0, 1, 2, 3],
      netex_experimental: [0, 1, 2, 3],
      gtfs: [4, 5],
      netex_france: [6, 7, 8, 9, 10]
    }
  end
end
