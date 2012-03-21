class ApplicationMap

  include MapLayers
  include MapLayers::ViewHelpers
  #delegate :url_helpers, :to => :'Rails.application.routes' 
  include Rails.application.routes.url_helpers
  
  def projection(name)
    OpenLayers::Projection.new(name)
  end

  def id
    "map"
  end

  def controls
    []
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
    "<div id=\"#{id}\" class=\"#{default_class}\"></div> #{map.to_html(options)}"
  end

  def kml
    OpenLayers::Format::KML.new :extractStyles => true, :extractAttributes => true, :maxDepth => 2
  end

  def strategy_fixed
    OpenLayers::Strategy::Fixed.new :preload => true
  end

  def kml_layer(url, options = {})   
    url = polymorphic_path([url.referential, url], :format => :kml) unless String === url 
    protocol = OpenLayers::Protocol::HTTP.new :url => url, :format => kml
    OpenLayers::Layer::Vector.new name, {:projection => projection("EPSG:4326"), :strategies => [strategy_fixed], :protocol => protocol}.merge(options)
  end

end
