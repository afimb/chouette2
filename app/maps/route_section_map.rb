class RouteSectionMap < ApplicationMap

  attr_reader :route_section

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(route_section, editable = false)
    @route_section = route_section
    @editable = editable
  end

  def customize_map(map, page)
    # layers order seems to matter for ModifyFeature control
    route_section.stop_areas.each do |stop_area|
      layer = "stop_area_#{stop_area.id}".to_sym
      page.assign layer.to_s, kml_layer(stop_area, :styleMap => Design::StopAreasStyleMap.new(helpers).style_map)
      page << map.add_layer(layer)
      page << map.add_control( hover_control_display_name(layer) )
    end

    geometry_options = {}.tap do |options|
      options[:mode] = :editable if editable?
    end
    geometry_uneditable_kml_layer = kml_layer(route_section, :styleMap => Design::RouteSectionSelectorStyleMap.new(helpers).style_map)
    page << map.add_layer(geometry_uneditable_kml_layer)

    if route_section.input_geometry
      geometry_editable_layer = kml_layer(route_section, geometry_options, {}) # , :styleMap => Design::LineStyleMap.new(style: nil).style_map)
    else
      points = route_section.stop_areas.map{|point| OpenLayers::Geometry::Point.new(point.longitude, point.latitude).transform("EPSG:4326", "EPSG:900913")}
      geometry_editable_layer = OpenLayers::Layer::Vector.new("user_geometry", {:projection => projection("EPSG:4326"), :styleMap => Design::RouteSectionStyleMap.new(helpers).style_map})
      #geometry_editable_layer = OpenLayers::Layer::Vector.new("user_geometry", {:projection => projection("EPSG:4326")})
      geometry_editable_features = OpenLayers::Feature::Vector.new(OpenLayers::Geometry::LineString.new(points))
      page.assign :geometry_editable_features, geometry_editable_features
    end

    if editable
      page.assign :user_geometry, geometry_editable_layer

      page << "user_geometry.addFeatures([geometry_editable_features])" if geometry_editable_features

      page << map.add_layer(:user_geometry)

      page.assign :modify_feature, OpenLayers::Control::ModifyFeature.new(:user_geometry, autoActivate: true)
      page << map.add_control( :modify_feature )
    else
      page << map.add_layer(geometry_editable_layer)
    end

    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def bounds
    @bounds ||=
      if route_section.geometry.present?
        route_section.geometry.bounds
      elsif route_section.stop_areas.present?
        GeoRuby::SimpleFeatures::Point.bounds route_section.stop_areas.collect(&:geometry)
      end
  end

  def ready?
    bounds.present?
  end

end
