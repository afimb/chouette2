class StyleMap::EditStopAreaStyleMap < StyleMap::GenericStyleMap
  
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
      :labelYOffset => -15,
      :pointRadius => 4,
      :fillColor => "white",
      :fillOpacity => 1,
      :strokeColor => "black",
      :strokeOpacity => 1,
      :strokeWidth => 2,
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
      :pointRadius => 4,
      :fillColor => "white",
      :fillOpacity => 1,
      :strokeColor => "black",
      :strokeOpacity => 1,
      :strokeWidth => 2,
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
      :areaType => :" function(feature) { console.log(feature); return feature.attributes.stop_area_type.toLowerCase();} "
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(default_style,  { :context => context}),
                             :select => OpenLayers::Style.new(select_style,  { :context => context})
                             )
  end

end
