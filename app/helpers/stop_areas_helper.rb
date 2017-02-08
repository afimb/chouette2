module StopAreasHelper
  def explicit_name(stop_area)
    name = localization = ""
    
    name += truncate(stop_area.name, :length => 30) || ""
    name += (" <small>["+ ( truncate(stop_area.registration_number, :length => 10) || "") + "]</small>") if stop_area.registration_number
    
    localization += stop_area.zip_code || ""
    localization += ( truncate(stop_area.city_name, :length => 15) ) if stop_area.city_name
    
    ( "<img src='#{stop_area_picture_url(stop_area)}'/>" + " <span style='height:25px; line-height:25px; margin-left: 5px; '>" + name + " <small style='height:25px; line-height:25px; margin-left: 10px; color: #555;'>" + localization + "</small></span>").html_safe
  end
  
  def genealogical_title 
    t("stop_areas.genealogical.genealogical")
  end
 
  def show_map?
    @stop_area.long_lat_type != nil
  end  

  def manage_access_points
    Chouette::AreaType.list_access_points.include? @stop_area.stop_area_type
  end

  def manage_children(referential_format)
    return false if ['boarding_position', 'quay', 'zone_d_embarquement', 'stop'].include? @stop_area.stop_area_type.to_s
    Chouette::AreaType.list_children(referential_format, @stop_area.stop_area_type.to_s).any?
  end
  
  def access_links_pairs(access_links)
    hpairs = Hash.new
    pairs = Array.new
    access_links.each do |link|
      key = pair_key(link)
      pair = nil
      if (hpairs.has_key? key)
        pair = hpairs[key]
      else
        pair = AccessLinkPair.new
        pairs << pair
        hpairs[key] = pair
      end
      if (link.link_orientation_type == "access_point_to_stop_area")
        pair.from_access_point = link
      else
        pair.to_access_point = link
      end
    end
    pairs
  end
  
  def pair_key(access_link)
    "#{access_link.access_point.id}-#{access_link.stop_area.id}"
  end

  def confirm_count_missing_geometry
    I18n.t('stop_areas.actions.default_geometry_confirm', { count: @referential.stop_areas.without_geometry.count })
  end

end
