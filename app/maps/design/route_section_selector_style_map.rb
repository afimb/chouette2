class Design::RouteSectionSelectorStyleMap < Design::GenericStyleMap
  attr_accessor :style

  def initialize(helpers, options = {})
    @helpers = helpers
    @style = options[:style].present? ? default_style.merge(options[:style]) : default_style
  end

  def select_style
    {
      fillColor: "blue",
      graphicName: "square",
      rotation: 90,
      strokeColor: "#00dd00",
      pointRadius: 15,
      graphicZIndex: 100
    }
  end

  def highlight_style
    {
      fillColor: "orange",
      graphicName: "square",
      rotation: 90,
      strokeColor: "#dd0000",
      pointRadius: 15,
      graphicZIndex: 200
    }
  end

  def default_style
    {
      label: "${label}",
      fontColor: "black",
      fontSize: "11px",
      fontWeight: "bold",
      labelAlign: "ct",
      labelXOffset: 0,
      labelYOffset: -15,
      strokeColor: "#0000dd",
      strokeOpacity: 1,
      strokeWidth: 3,
      strokeLineCap: "round",
      strokeDashstyle: "solid",
      externalGraphic: @helpers.assets_path_patch( "map/${positionType}.png"),
      graphicWidth: 12,
      graphicHeight: 12,
      graphicOpacity: 1,
      graphicXOffset: -6,
      graphicYOffset: -6,
      display: true,
      fillColor: "red",
      graphicName: "square",
      rotation: 90,
      graphicZIndex: 10
    }
  end

  def context
    {
      label: :" function(feature) {if(feature.layer.map.getZoom() > 13) { return feature.attributes.name;} else {return '';}} ",
      positionType: :" function(feature) { if (feature.attributes.iconCode != undefined) {return feature.attributes.iconCode;} else { return '';} } "
    }
  end

  def style_map
    OpenLayers::StyleMap.new(
        default: OpenLayers::Style.new(style, { context: context}),
        select: OpenLayers::Style.new(style.merge(select_style), { context: context }),
        highlight: OpenLayers::Style.new(style.merge( highlight_style), { context: context }))
  end

end
