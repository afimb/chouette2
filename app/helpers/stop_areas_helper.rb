module StopAreasHelper
  def genealogical_title
    return t("genealogical_routing") if @stop_area.stop_area_type == 'itl'    
    t("genealogical")
  end
 
  def show_map?
    manage_itl || @stop_area.long_lat_type != nil
  end  

  def manage_access_points
    @stop_area.stop_area_type == 'stop_place' || @stop_area.stop_area_type == 'commercial_stop_point'
  end
  def manage_itl
    @stop_area.stop_area_type == 'itl'
  end
  def manage_parent
    @stop_area.stop_area_type != 'itl'
  end
  def manage_children
    @stop_area.stop_area_type == 'stop_place' || @stop_area.stop_area_type == 'commercial_stop_point'
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


end
