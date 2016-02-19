module RouteSectionSelectorsHelper

  def link_to_edit_route_section(route_section)
    classes = [ 'edit-route-section' ]
    link ='#'

    if route_section.present?
      return_to = edit_referential_line_route_journey_pattern_route_sections_selector_path(@referential, @line, @route, @journey_pattern)
      link = edit_referential_route_section_path(@referential, route_section, return_to: return_to)
    else
      classes << 'disabled'
    end

    link_to "Edit", link, class: classes, title: t('route_sections_selectors.edit.route_section.edit')
  end

  def link_to_create_route_section(departure, arrival)
    return_to = edit_referential_line_route_journey_pattern_route_sections_selector_path(@referential, @line, @route, @journey_pattern)
    link_to t('route_sections_selectors.edit.route_section.new'),
            create_to_edit_referential_route_sections_path(@referential, route_section: {departure_id:departure.id, arrival_id: arrival.id}, return_to: return_to)
  end

end
