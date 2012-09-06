class StyleMap::StopAreasStyleMap < StyleMap::GenericStyleMap
  attr_accessor :default_style, :context
  
  @@default_style_class = {
    :label => "${label}",
    :fontColor => "black",
    :fontSize => "11px",
    :fontWeight => "bold",
    :labelAlign => "ct",
    :labelXOffset => 0,
    :labelYOffset => -40,
    :pointRadius => 1, 
    :externalGraphic => polymorphic_path_patch( "map/${areaType}.png"),      
    :graphicWidth => 25,
    :graphicHeight => 25, 
    :graphicOpacity => 1,    
    :graphicXOffset => -12.5,
    :graphicYOffset => -12.5
  }

  def initialize(options = {})
    @default_style = options[:default_style].present? ? options[:default_style].merge(@@default_style_class) : @@default_style_class
  end

  
  def context
    {
      :label => :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} ", 
      :areaType => :" function(feature) { return feature.attributes.stop_area_type.toLowerCase();} " 
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(default_style, { :context => context})                             )
  end

end
