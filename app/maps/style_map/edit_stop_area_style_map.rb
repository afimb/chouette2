class StyleMap::EditStopAreaStyleMap < StyleMap::GenericStyleMap
  attr_accessor :default_style, :select_style, :context
  
  @@default_style_class = {
    #:label => "${label}",
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
    :strokeWidth => 2
  }

  @@select_style_class = {
    :fontColor => "black", 
    :fontSize => "11px",
    :fontWeight => "bold",
    :pointRadius => 4,
    :fillColor => "#86b41d",
    :fillOpacity => 1,
    :strokeColor => "black",
    :strokeOpacity => 1,
    :strokeWidth => 2
  }

  def initialize(options = {})
    @default_style = options[:default_style].present? ? options[:default_style].merge(@@default_style_class) : @@default_style_class
    @select_style = options[:select_style].present? ? options[:select_style].merge(@@select_style_class) : @@select_style_class
  end

  def context
    { 
      :label => :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} "
    }
  end

  def style_map
    OpenLayers::StyleMap.new(
                             :default => OpenLayers::Style.new(default_style,  { :context => context}),
                             :select => OpenLayers::Style.new(select_style)
                             )
  end

end
