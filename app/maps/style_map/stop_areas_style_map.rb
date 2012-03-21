class StyleMap::StopAreasStyleMap < StyleMap::GenericStyleMap
  
  attr_accessor :styles, :display_label, :context, :terminus
  alias_method :terminus?, :terminus

  def initialize(display_label = false, terminus = false, context = {}, styles = {})
    @display_label = display_label
    @terminus = terminus
    @context = context
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
    }.tap do |style_basic|
      style_basic.merge! :fontSize =>"11px", 
      :pointRadius => 16, 
      :externalGraphic => "/assets/icons/stop_area_hover.png" if terminus?
    end
    
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
    }.tap do |style_basic|
      style_basic.merge! :fontSize =>"11px", 
      :pointRadius => 16, 
      :externalGraphic => "/assets/icons/stop_area_hover.png" if terminus?
    end
    if styles["select"].present?
      select_style.merge styles["select"]
    else
      select_style
    end
  end
  
  def context
    context = { 
      :label => :"function(feature) {if(feature.layer.map.getZoom() > 15) { return feature.attributes.name;} else {return '';}}", 
      #:display => :"function(feature) {if(feature.layer.map.getZoom() > 13) { return true;} else {return 'none';}}" 
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(default_style,  { :context => context}),
                             :select => OpenLayers::Style.new(select_style,  { :context => context})
                             )
  end

end
