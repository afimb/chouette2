class Design::LineStyleMap < Design::GenericStyleMap
  attr_accessor :style, :line_priority, :line_color

  def initialize(helpers,options = {})
    @helpers= helpers
    @line_color = options[:line_color]
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  def stroke_width
    stroke_width = 3
  end

  def default_style
    style = {
      :strokeColor => line_color || "#000000",
      :strokeOpacity => 1,
      :strokeWidth => stroke_width,
      :strokeLineCap => "round",
      :strokeDashstyle => "solid",
    }
  end

  def style_map
    OpenLayers::StyleMap.new(:default => OpenLayers::Style.new(style))
  end

end
