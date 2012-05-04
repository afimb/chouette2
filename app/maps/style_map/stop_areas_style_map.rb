class StyleMap::StopAreasStyleMap < StyleMap::GenericStyleMap
  
  attr_accessor :styles, :display_label

  def initialize(display_label = false, styles = {})
    @display_label = display_label
    @styles = styles
  end

  def default_style
    style = {
      :label => ("${label}" if display_label),
      :fontColor => "black",
      :fontSize => "11px",
      :fontWeight => "bold",
      :labelAlign => "ct",
      :labelXOffset => 0,
      :labelYOffset => -40,
      :pointRadius => 1, 
      :externalGraphic => "/assets/map/${areaType}.png",
      :graphicWidth => 25,
      :graphicHeight => 25, 
      :graphicOpacity => 1,	
      :graphicXOffset =>	-12.5,
      :graphicYOffset =>	12.5,
      :display => true
    }   
    
    if styles["default"].present?
      style.merge styles["default"] 
    else
      style
    end
  end

  def select_style
    select_style = {
      :label => ("${label}" if display_label),
      :fontColor => "black", 
      :fontSize => "11px",
      :fontWeight => "bold",
      :labelAlign => "ct",
      :labelXOffset => 0,
      :labelYOffset => -15,
      :externalGraphic => "/assets/map/${areaType}.png",
      :graphicWidth => 25,
      :graphicHeight => 25, 
      :graphicOpacity => 1,	
      :graphicXOffset =>	12.5,
      :graphicYOffset =>	12.5,
      :display => true
    }

    if styles["select"].present?
      select_style.merge styles["select"]
    else
      select_style
    end
  end
  
  def context
    context = { 
      :label => :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} ", 
      :areaType => :" function(feature) { return feature.attributes.stop_area_type.toLowerCase();} " 
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(default_style,  { :context => context}),
                             :select => OpenLayers::Style.new(select_style,  { :context => context})
                             )
  end

end
