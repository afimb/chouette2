module ApplicationHelper
 
  def chouette_line_path(line)
    line_path(line)
  end

  def chouette_network_path(line)
    network_path(line)
  end

  def chouette_company_path(line)
    company_path(line)
  end

  def link_to_order(name, column)
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    Rails.logger.debug sort_direction.inspect
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc" 
    Rails.logger.debug direction.inspect
    link_to name, { :sort => column, :direction => direction}, {:class => css_class}
  end
  
end
