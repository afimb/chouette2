class Design::EditStopAreaStyleMap < Design::GenericStyleMap
  attr_accessor :style
  
  def default_style
    { :fontColor => "black",
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
      :strokeWidth => 2 } 
  end

  def select_style
   { :fontColor => "black", 
     :fontSize => "11px",
     :fontWeight => "bold",
     :pointRadius => 4,
     :fillColor => "#86b41d",
     :fillOpacity => 1,
     :strokeColor => "black",
     :strokeOpacity => 1,
     :strokeWidth => 2 }
  end

  def initialize(helpers, options = {})
    @helpers= helpers
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  def context
    { 
      :label => :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} "
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(style, { :context => context}), :select =>  OpenLayers::Style.new(style.merge( select_style), { :context => context}))
  end

end
