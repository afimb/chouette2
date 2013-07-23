class Chouette::Kml::StopAreaExporter
  include ERB::Util
  attr_accessor :stop_areas, :directory, :template, :area_type

  def initialize(stop_areas,directory,area_type)
    @stop_areas = stop_areas
    @directory = directory
    @area_type = area_type
    @template = File.open('app/views/api/kml/stop_areas/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def layer_name
    case area_type
    when "CommercialStopPoint"
      "Arrets commerciaux"
    when 'Quay', 'BoardingPosition'
      "Arrets physiques"
    when "StopPlace"
      "Poles d'echange"
    when "ITL"
      "ITL"
    end
  end

  def self.local_key(area_type)
    case area_type
    when "CommercialStopPoint"
      "EXPORT|COMMERCIAL_COUNT"
    when 'Quay', 'BoardingPosition'
      "EXPORT|QUAY_AND_BOARDING_POSITION_COUNT"
    when "StopPlace"
      "EXPORT|STOP_PLACE_COUNT"
    when "ITL"
      "EXPORT|ITL_COUNT"
    end
  end

  def kml_name
    case area_type
    when 'Quay', 'BoardingPosition'
      "stop_areas"
    when "CommercialStopPoint"
      "commercial_stop_areas"
    when "StopPlace"
      "stop_places"
    when "ITL"
      "itls"
    end
  end

  def file_extension
    ".kml"
  end

  def self.save( models, directory, kml_export, area_type)
    self.new( models, directory, area_type).tap do |specific_exporter|
      specific_exporter.save
    end
    kml_export.log_messages.create( :severity => "ok", :key => self.local_key(area_type), :arguments => {"0" => models.size})
  end

  def save
    File.open(File.join(directory, kml_name + file_extension), "w+") do |f|
      f.write(render)
    end if stop_areas.present?
  end
end

