class Design::RouteSectionStyleMap < Design::GenericStyleMap
  attr_accessor :style

  def initialize(helpers, options = {})
    @helpers= helpers
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  def select_style
    {
      fillColor:"blue",
      graphicName:"circle",
      rotation:90,
      :strokeColor => "red",
      pointerEvents: "visiblePainted"
    }
  end

  def highlight_style
    {
      fillColor:"lightblue",
      graphicName:"circle",
      rotation:90,
      :strokeColor => "#dd0000"
    }
  end

  def default_style

    {
      :fontColor => "black",
      :fontSize => "11px",
      :fontWeight => "bold",
      :labelAlign => "cm",
      :labelXOffset => 0,
      :labelYOffset => -15,
      :strokeColor => "green",
      :strokeOpacity => 1,
      :strokeWidth => 4,
      :strokeLineCap => "round",
      :strokeLineJoin => "round",
      :strokeDashstyle => "solid",
      :lineCap => "round",
      :lineJoin => "round",
      :dashstyle => "solid",
      :graphicWidth => 12,
      :graphicHeight => 12,
      :graphicOpacity => 1,
      :graphicXOffset => -6,
      :graphicYOffset => -6,
      :display => true,
      fillOpacity: 0.8,
      fillColor: "#ffffff",
      graphicName: "circle",
      pointRadius: 7,
      pointerEvents: "visiblePainted",
      rotation: 90
    }

  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(style), :select =>  OpenLayers::Style.new(style.merge( select_style)), :highlight =>  OpenLayers::Style.new(style.merge( highlight_style)))
  end

end
