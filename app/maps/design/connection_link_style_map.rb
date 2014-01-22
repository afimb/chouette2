class Design::ConnectionLinkStyleMap < Design::GenericStyleMap
  attr_accessor :style

  def initialize(helpers,options = {})
    @helpers= helpers
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  def default_style
    {
      :fontColor => "black", 
      :fontSize => "11px",
      :fontWeight => "bold",
      :labelAlign => "ct",
      :labelXOffset => 0,
      :labelYOffset => -15,
      :strokeColor => "#000000",
      :strokeOpacity => 1,
      :strokeWidth => 3,
      :strokeLineCap => "round",
      :strokeDashstyle => "solid",
      :externalGraphic => @helpers.assets_path_patch( "map/${positionType}.png"),
      :graphicWidth => 36,
      :graphicHeight => 36, 
      :graphicOpacity => 1,	
      :graphicXOffset => -18,
      :graphicYOffset => -18,
      :display => true
    }
  end

  def context
    context = { 
      :positionType => :" function(feature) { if (feature.attributes.departure != undefined) { return 'departure'; } else { return 'arrival'; }} " 
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(style, { :context => context}))
  end

end

