class AddressesController < ChouetteController
  
  belongs_to :referential

  def index
    referential_path(@referential)
    #Rails.logger.error("SEARCHING FOR ADDRESSES : #{params[:q]}")
    @addresses = filtered_addresses
    #Rails.logger.error("ADDRESSES : #{@addresses.inspect}")
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
end
