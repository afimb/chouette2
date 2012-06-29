class ApplicationMap

  include MapLayers
  include MapLayers::ViewHelpers

  attr_accessor :helpers

  def helpers
    @helper ||= Helpers.new
  end

  # For example, in a controller :
  #
  #   @map = MyMap.new(...).with_helpers(self)
  #
  def with_helpers(helpers)
    self.helpers = helpers
    self
  end

  class Helpers
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
  end

  def projection(name)
    OpenLayers::Projection.new(name)
  end

  def controls
    [ OpenLayers::Control::LayerSwitcher.new(:ascending => true),
      OpenLayers::Control::ScaleLine.new,
      OpenLayers::Control::Navigation.new,
      OpenLayers::Control::PanZoomBar.new,
      OpenLayers::Control::Attribution.new]
  end

  def id
    "map"
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls)
  end

  def name
    self.class.name.underscore.gsub(/_map$/, '')
  end
  alias_method :default_class, :name

  def to_html(options = {})
    if not respond_to?(:ready?) or ready?
      "<div id=\"#{id}\" class=\"#{default_class}\"></div> #{map.to_html(options)}".html_safe
    end
  end

  def kml
    OpenLayers::Format::KML.new :extractStyles => true, :extractAttributes => true, :maxDepth => 2
  end

  def strategy_fixed
    OpenLayers::Strategy::Fixed.new :preload => true
  end

  def google_physical
    OpenLayers::Layer::Google.new("Google Physical",
                      :type => :"google.maps.MapTypeId.TERRAIN")
  end

  def google_streets
    OpenLayers::Layer::Google.new "Google Streets", :numZoomLevels => 20
  end

  def google_hybrid
    OpenLayers::Layer::Google.new "Google Hybrid", :type => :"google.maps.MapTypeId.HYBRID", :numZoomLevels => 20
  end
  
  def google_satellite
    OpenLayers::Layer::Google.new "Google Satellite", :type => :"google.maps.MapTypeId.SATELLITE", :numZoomLevels => 22
  end

  def hover_control_display_name(layer)
    OpenLayers::Control::SelectFeature.new( layer, { 
                                              :autoActivate => true,
                                              :hover => true,
                                              :renderIntent => "temporary",
                                              :eventListeners => {
                                                :featurehighlighted => JsExpr.new("function(e) {
          feature = e.feature ;
          popup = new OpenLayers.Popup.AnchoredBubble('chicken', 
                                                 new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y),
                                                 null,
                                                 \"<div class='popup_hover'><b>\" + feature.attributes.name +\"</b></div> \", null, false, null);
          popup.autoSize = true;
          popup.displayClass = 'popup_hover';

          feature.popup = popup;
          map.addPopup(popup);
        }"),
                                                :featureunhighlighted => JsExpr.new("function(e) {
          feature = e.feature;
          map.removePopup(feature.popup);
          feature.popup.destroy();
          feature.popup = null;  
        }")
                                              } } )
  end

  def kml_layer(url_or_object, options_or_url_options = {}, options = nil)   
    unless options
      url_options = {}
      options = options_or_url_options
    else
      url_options = options_or_url_options
    end

    url_options = url_options.merge(:format => :kml)

    url =
      case url_or_object
      when String
        url_or_object
      when Array
        helpers.polymorphic_path(url_or_object, url_options)
      else
        helpers.polymorphic_path([url_or_object.referential, url_or_object], url_options)
      end
    
    protocol = OpenLayers::Protocol::HTTP.new :url => url, :format => kml
    OpenLayers::Layer::Vector.new name, {:projection => projection("EPSG:4326"), :strategies => [strategy_fixed], :protocol => protocol, :displayInLayerSwitcher => false}.merge(options)
  end

end
