# -*- coding: utf-8 -*-
class StopAreasController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :default_geometry, :zip_codes]

  defaults :resource_class => Chouette::StopArea

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
    belongs_to :network, :parent_class => Chouette::Network, :optional => true, :polymorphic => true
    belongs_to :connection_link, :parent_class => Chouette::ConnectionLink, :optional => true, :polymorphic => true
  end

  respond_to :html, :kml, :xml, :json
  respond_to :js, :only => :index

  # def complete
  #   @stop_areas = line.stop_areas
  #   render :layout => false
  # end

  def select_parent
    @stop_area = stop_area
    @parent = stop_area.parent
    build_breadcrumb :edit
  end

  def add_children
    @stop_area = stop_area
    @children = stop_area.children
    build_breadcrumb :edit
  end

  def add_routing_lines
    @stop_area = stop_area
    @lines = stop_area.routing_lines
    build_breadcrumb :edit
  end

  def add_routing_stops
    @stop_area = stop_area
    build_breadcrumb :edit
  end

  def access_links
    @stop_area = stop_area
    @generic_access_links = stop_area.generic_access_link_matrix
    @detail_access_links = stop_area.detail_access_link_matrix
    build_breadcrumb :edit
  end

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12
    @zip_codes = referential.stop_areas.collect(&:zip_code).compact.uniq
    index! do |format|
      format.html {
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
        build_breadcrumb :index
      }
    end
  end

  def new
    @map = StopAreaMap.new( Chouette::StopArea.new).with_helpers(self)
    @map.editable = true
    new! do
      build_breadcrumb :show
    end
  end

  def create
    @map = StopAreaMap.new( Chouette::StopArea.new).with_helpers(self)
    @map.editable = true

    create!
  end

  def show
    map.editable = false
    @access_points = @stop_area.access_points
    show! do |format|
      unless stop_area.position or params[:default] or params[:routing]
        format.kml {
          render :nothing => true, :status => :not_found
        }

      end
      build_breadcrumb :show
    end
  end

  def edit
    edit! do
      stop_area.position ||= stop_area.default_position
      map.editable = true
      build_breadcrumb :edit
   end
  end

  def update
    stop_area.position ||= stop_area.default_position
    map.editable = true

    update!
  end

  def default_geometry
    count = referential.stop_areas.without_geometry.default_geometry!
    flash[:notice] = I18n.translate("stop_areas.default_geometry_success", :count => count)
    redirect_to referential_stop_areas_path(@referential)
  end

  def zip_codes
    respond_to do |format|
      format.json { render :json => referential.stop_areas.collect(&:zip_code).compact.uniq.to_json }
    end
  end

  protected

  alias_method :stop_area, :resource

  def map
    @map = StopAreaMap.new(stop_area).with_helpers(self)
  end

  def collection
    @q = parent.present? ? parent.stop_areas.search(params[:q]) : referential.stop_areas.search(params[:q])
    @stop_areas ||=
      begin
        stop_areas = @q.result(:distinct => true).order(:name)
        stop_areas = stop_areas.page(params[:page]).per(@per_page) if @per_page.present?
        stop_areas
      end
  end

  private

  def stop_area_params
    params.require(:stop_area).permit(:compass_bearing, :routing_stop_ids, :routing_line_ids, :children_ids, :stop_area_type, :parent_id, :objectid, :object_version, :creation_time,
    :creator_id, :name, :comment, :area_type, :registration_number, :nearest_topic_name, :fare_code, :longitude, :latitude, :long_lat_type,
    :country_code, :street_name, :zip_code, :city_name, :mobility_restricted_suitability, :stairs_availability, :lift_availability, :int_user_needs,
    :coordinates, :url, :time_zone)
  end

end
