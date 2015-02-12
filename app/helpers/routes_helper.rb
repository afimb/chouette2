module RoutesHelper

  def line_formatted_name( line)
    return line.published_name if line.number.blank?
    "#{line.published_name} [#{line.number}]"
  end

  def fonticon_wayback(wayback)
    if wayback == "A"
      return '<i class="fa fa-arrow-right"></i>'.html_safe
    else
      return '<i class="fa fa-arrow-left"></i>'.html_safe  
    end
  end
  
end
