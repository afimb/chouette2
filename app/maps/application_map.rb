class ApplicationMap

  include MapLayers
  include MapLayers::ViewHelpers

  attr_accessor :helpers
  cattr_accessor :ign_api_key

  def helpers
    @helpers ||= Helpers.new
  end

  # For example, in a controller :
  #
  #   @map = MyMap.new(...).with_helpers(self)
  #
  def with_helpers(helpers)
    self.helpers = helpers
    self
  end

  def geoportail_key
    if ( Rails.application.secrets.respond_to? :geoportail_api_key)
      return Rails.application.secrets.geoportail_api_key
    end
    return nil
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
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      if self.geoportail_key
        page << map.add_layer(geoportail_ortho_wmts)
        page << map.add_layer(geoportail_scans_wmts)
        page << map.add_layer(geoportail_cadastre_wmts)
      end

      page << map.add_layer(MapLayers::OSM_MAPNIK)
      #page << map.add_layers([geoportail_scans, geoportail_ortho])
      page << map.add_layer(google_physical)
      page << map.add_layer(google_streets)
      page << map.add_layer(google_hybrid)
      page << map.add_layer(google_satellite)

      customize_map(map,page) if respond_to?( :customize_map)
    end
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
  def geoportail_cadastre_wmts
    OpenLayers::Layer::WMTS.new( geoportail_options.update(:name => I18n.t("maps.ign_cadastre"),
        :format => "image/png",
        :layer => "CADASTRALPARCELS.PARCELS"))
  end

  def geoportail_ortho_wmts
    OpenLayers::Layer::WMTS.new( geoportail_options.update(:name => I18n.t("maps.ign_ortho"),
        :layer => "ORTHOIMAGERY.ORTHOPHOTOS"))
  end

  def geoportail_scans_wmts
    OpenLayers::Layer::WMTS.new( geoportail_options.update(:name => I18n.t("maps.ign_map"),
        :layer => "GEOGRAPHICALGRIDSYSTEMS.MAPS"))
  end

  def geoportail_options
    { :url => "http://gpp3-wxs.ign.fr/#{self.geoportail_key}/wmts",
        :matrixSet => "PM",
        :style => "normal",
        :numZoomLevels => 19,
        :group => "IGN",
	:attribution => 'Map base: &copy;IGN <a href="http://www.geoportail.fr/" target="_blank"><img src="http://api.ign.fr/geoportail/api/js/2.0.0beta/theme/geoportal/img/logo_gp.gif"></a> <a href="http://www.geoportail.gouv.fr/depot/api/cgu/licAPI_CGUF.pdf" alt="TOS" title="TOS" target="_blank">Terms of Service</a>'}
  end

  def strategy_fixed
    OpenLayers::Strategy::Fixed.new :preload => true
  end

  def google_physical
    OpenLayers::Layer::Google.new(I18n.t("maps.google_physical"),
                      :type => :"google.maps.MapTypeId.TERRAIN")
  end

  def google_streets
    OpenLayers::Layer::Google.new I18n.t("maps.google_streets"), :numZoomLevels => 20
  end

  def google_hybrid
    OpenLayers::Layer::Google.new I18n.t("maps.google_hybrid"), :type => :"google.maps.MapTypeId.HYBRID", :numZoomLevels => 20
  end

  def google_satellite
    OpenLayers::Layer::Google.new I18n.t("maps.google_satellite"), :type => :"google.maps.MapTypeId.SATELLITE", :numZoomLevels => 22
  end

  def hover_control_display_name(layer)
    OpenLayers::Control::SelectFeature.new( layer, {
                                              :autoActivate => true,
                                              :hover => true,
                                              :renderIntent => "temporary",
                                              :eventListeners => {
                                                :featurehighlighted => JsExpr.new("function(e) {
          var feature = e.feature ;
          if (feature.attributes.inactive != undefined)
            return;
          var popup = new OpenLayers.Popup.Anchored('chicken',
                                                 new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y),
                                                 null,
                                                 \"<div class='popup_hover'><p><b>\" + feature.attributes.name +\"</b><p>\" + feature.attributes.stop_area_type_label + \"</div> \", null, false, null);
          popup.autoSize = true;
          popup.displayClass = 'popup_hover';

          feature.popup = popup;
          map.addPopup(popup);
        }"),
                                                :featureunhighlighted => JsExpr.new("function(e) {
          var feature = e.feature;
          if (feature.attributes.inactive != undefined)
            return;
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
        helpers.polymorphic_path_patch( helpers.polymorphic_path(url_or_object, url_options))
      else
        helpers.polymorphic_path_patch( helpers.polymorphic_path([url_or_object.referential, url_or_object], url_options))
      end

    protocol = OpenLayers::Protocol::HTTP.new :url => url, :format => kml
    OpenLayers::Layer::Vector.new name, {:projection => projection("EPSG:4326"), :strategies => [strategy_fixed], :protocol => protocol, :displayInLayerSwitcher => false}.merge(options)
  end

end
