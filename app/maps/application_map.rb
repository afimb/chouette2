class ApplicationMap

  include MapLayers
  include MapLayers::ViewHelpers
  #delegate :url_helpers, :to => :'Rails.application.routes' 
  include Rails.application.routes.url_helpers
  
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

  def default_class
    self.class.name.underscore.gsub(/_map$/, '')
  end

  def name
    self.class.name.underscore.gsub(/_map$/, '')
  end

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

  def kml_layer(url, options = {})   
    url = polymorphic_path([url.referential, url], :format => :kml) unless String === url 
    protocol = OpenLayers::Protocol::HTTP.new :url => url, :format => kml
    OpenLayers::Layer::Vector.new name, {:projection => projection("EPSG:4326"), :strategies => [strategy_fixed], :protocol => protocol, :displayInLayerSwitcher => false}.merge(options)
  end

end
