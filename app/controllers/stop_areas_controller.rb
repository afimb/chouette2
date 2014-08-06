# -*- coding: utf-8 -*-
class StopAreasController < ChouetteController
  defaults :resource_class => Chouette::StopArea

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
    belongs_to :network, :parent_class => Chouette::Network, :optional => true, :polymorphic => true
    belongs_to :connection_link, :parent_class => Chouette::ConnectionLink, :optional => true, :polymorphic => true
  end

  respond_to :html, :kml, :xml, :json

  layout "without_sidebar", :only => [:edit, :update]

  # def complete
  #   @stop_areas = line.stop_areas
  #   render :layout => false
  # end

  def select_parent
    @stop_area = stop_area
    @parent = stop_area.parent
  end

  def add_children
    @stop_area = stop_area
    @children = stop_area.children
  end

  def add_routing_lines
    @stop_area = stop_area
    @lines = stop_area.routing_lines
  end

  def add_routing_stops
    @stop_area = stop_area
    @stops = stop_area.routing_stops
  end

  def access_links
    @stop_area = stop_area
    @generic_access_links = stop_area.generic_access_link_matrix
    @detail_access_links = stop_area.detail_access_link_matrix
  end

  def index    
    request.format.kml? ? @per_page = nil : @per_page = 12
    @country_codes = referential.stop_areas.collect(&:country_code).compact.uniq
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      }
    end       
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
    end
  end
  
  def edit
    stop_area.position ||= stop_area.default_position

    map.editable = true
    edit!
  end

  def default_geometry
    count = referential.stop_areas.without_geometry.default_geometry!
    flash[:notice] = I18n.translate("stop_areas.default_geometry_success", :count => count)
    redirect_to referential_stop_areas_path(@referential)
  end

  def country_codes
    respond_to do |format|
      format.json { render :json => referential.stop_areas.collect(&:country_code).compact.uniq.to_json }
    end
  end

  def addresses
    Rails.logger.error("SEARCHING FOR ADDRESSES : #{params[:q]}")
    @addresses = filtered_addresses
    respond_to do |format|
      format.json { render :json => @addresses.collect { |add| { :id => add.osm_id, 
            :house_number => add.address ? "#{add.address.house_number}" : -1, 
            :road => add.address ? "#{add.address.road}" : "#{add.display_name}",
            :postcode => add.address ? "#{add.address.postcode}" : -1,
            :city => add.address ? "#{add.address.city}" : -1,
            :country => add.address ? "#{add.address.country}" : -1,
            :lat => add.lat,
            :lon => add.lon} } } 
    end
  end
  
  protected
  
  #def filtered_addresses_maps
  #  filtered_addresses.collect do |address|
  #    { :address_name => address.display_name, :address_type => address.type }
  #  end
  #end
  
  def filtered_addresses
    search = Nominatim.search(params[:q]).limit(10)
    addresses = search.address_details(true)
    #search.each_address do |sr|
    #  Rails.logger.error("FILTERED ADRESS = #{sr.inspect}")
    #  Rails.logger.error("\tATTRACTION  = #{sr.attraction.inspect}")
    #  Rails.logger.error("\tCLOTHES  = #{sr.clothes.inspect}")
    #  Rails.logger.error("\tHOUSE_NUMBER  = #{sr.house_number.inspect}")
    #  Rails.logger.error("\tROAD  = #{sr.road.inspect}")
    #  Rails.logger.error("\tCOMMERCIAL  = #{sr.commercial.inspect}")
    #  Rails.logger.error("\tPEDESTRIAN  = #{sr.pedestrian.inspect}")
    #  Rails.logger.error("\tSUBURB  = #{sr.suburb.inspect}")
    #  Rails.logger.error("\tCITY_DISTRICT  = #{sr.city_district.inspect}")
    #  Rails.logger.error("\tCITY  = #{sr.city.inspect}")
    #  Rails.logger.error("\tADMINISTRATIVE  = #{sr.administrative.inspect}")
    #  Rails.logger.error("\tCOUNTY  = #{sr.county.inspect}")
    #  Rails.logger.error("\tSTATE_DISTRICT  = #{sr.state_district.inspect}")
    #  Rails.logger.error("\tSTATE  = #{sr.state.inspect}")
    #  Rails.logger.error("\tPOSTCODE  = #{sr.postcode.inspect}")
    #  Rails.logger.error("\tCOUNTRY  = #{sr.country.inspect}")
    #  Rails.logger.error("\tCOUNTRY_CODE  = #{sr.country_code.inspect}")
    #  Rails.logger.error("\tPLACE  = #{sr.place.inspect}")
    #  Rails.logger.error("\tTOWN  = #{sr.town.inspect}")
    #  Rails.logger.error("\tVILLAGE  = #{sr.village.inspect}")
    #end
    #if addresses
    #  addresses.each do |ad|
    #    Rails.logger.error("FILTERED PLACE : #{ad.inspect}")
    #    Rails.logger.error("\tDISPLAY_NAME = #{ad.display_name.inspect}")
    #    Rails.logger.error("\tCLASS = #{ad.class.inspect}")
    #    Rails.logger.error("\tTYPE = #{ad.type.inspect}")
    #    Rails.logger.error("\tADRRESS = #{ad.address.inspect}")
    #    if ad.address
    #      Rails.logger.error("\t\tATTRACTION  = #{ad.address.attraction.inspect}")
    #      Rails.logger.error("\t\tCLOTHES  = #{ad.address.clothes.inspect}")
    #      Rails.logger.error("\t\tHOUSE_NUMBER  = #{ad.address.house_number.inspect}")
    #      Rails.logger.error("\t\tROAD  = #{ad.address.road.inspect}")
    #      Rails.logger.error("\t\tCOMMERCIAL  = #{ad.address.commercial.inspect}")
    #      Rails.logger.error("\t\tPEDESTRIAN  = #{ad.address.pedestrian.inspect}")
    #      Rails.logger.error("\t\tSUBURB  = #{ad.address.suburb.inspect}")
    #      Rails.logger.error("\t\tCITY_DISTRICT  = #{ad.address.city_district.inspect}")
    #      Rails.logger.error("\t\tCITY  = #{ad.address.city.inspect}")
    #      Rails.logger.error("\t\tADMINISTRATIVE  = #{ad.address.administrative.inspect}")
    #      Rails.logger.error("\t\tCOUNTY  = #{ad.address.county.inspect}")
    #      Rails.logger.error("\t\tSTATE_DISTRICT  = #{ad.address.state_district.inspect}")
    #      Rails.logger.error("\t\tSTATE  = #{ad.address.state.inspect}")
    #      Rails.logger.error("\t\tPOSTCODE  = #{ad.address.postcode.inspect}")
    #      Rails.logger.error("\t\tCOUNTRY  = #{ad.address.country.inspect}")
    #      Rails.logger.error("\t\tCOUNTRY_CODE  = #{ad.address.country_code.inspect}")
    #      Rails.logger.error("\t\tPLACE  = #{ad.address.place.inspect}")
    #      Rails.logger.error("\t\tTOWN  = #{ad.address.town.inspect}")
    #      Rails.logger.error("\t\tVILLAGE  = #{ad.address.village.inspect}")
    #    end
    #    Rails.logger.error("\tLAT = #{ad.lat.inspect}")
    #    Rails.logger.error("\tLON = #{ad.lon.inspect}")
    #    Rails.logger.error("\tBOUNDINGBOX = #{ad.boundingbox.inspect}")
    #    Rails.logger.error("\tPOLYGONPOINTS = #{ad.polygonpoints.inspect}")
    #    Rails.logger.error("\tPLACE_ID = #{ad.place_id.inspect}")
    #    Rails.logger.error("\tOSM_ID = #{ad.osm_id.inspect}")
    #    Rails.logger.error("\tOSM_TYPE = #{ad.osm_type.inspect}")
    #  end
    #end
    #polygons = search.polygon(true)
    #if polygons
    #  polygons.each do |po|
    #    Rails.logger.error("FILTERED POLYGON : #{po.polygonpoints.inspect}")
    #    if po.polygonpoints
    #      if po.polygonpoints.coordinates
    #        po.polygonpoints.coordinates.each do |point|
    #          Rails.logger.error("\tPOINT  = #{point.inspect}")
    #          Rails.logger.error("\t\tLAT  = #{point.lat.inspect}")
    #          Rails.logger.error("\t\tLON  = #{point.lon.inspect}")
    #        end
    #      end
    #    end
    #  end
    #end
    return addresses
  end
  
  alias_method :stop_area, :resource

  def map
    @map = StopAreaMap.new(stop_area).with_helpers(self)
  end

  def collection
    @q = parent.present? ? parent.stop_areas.search(params[:q]) : referential.stop_areas.search(params[:q])
    @stop_areas ||= 
      begin
        stop_areas = @q.result(:distinct => true).order(:name)
        stop_areas = stop_areas.paginate(:page => params[:page], :per_page => @per_page) if @per_page.present?
        stop_areas
      end
  end

end
