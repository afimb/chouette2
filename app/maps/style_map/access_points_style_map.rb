class StyleMap::AccessPointsStyleMap < StyleMap::GenericStyleMap
  attr_accessor :style, :context
  
  def default_style
    raise "Helpers nil" if @helpers.nil?
    {:label => "${label}",
     :fontColor => "black",
     :fontSize => "11px",
     :fontWeight => "bold",
     :labelAlign => "ct",
     :labelXOffset => 0,
     :labelYOffset => -40,
     :pointRadius => 1, 
     :externalGraphic => @helpers.assets_path_patch( "map/access_${accessType}.png"),      
     :graphicWidth => 25,
     :graphicHeight => 25, 
     :graphicOpacity => 1,    
     :graphicXOffset => -12.5,
     :graphicYOffset => -12.5 }
  end

  def initialize(helpers,options = {})
    @helpers= helpers
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  
  def context
    {
      :label => :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} ", 
      :accessType => :" function(feature) { return feature.attributes.access_type.toLowerCase();} " 
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(style, { :context => context})                             )
  end

end
