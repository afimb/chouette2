module LinesHelper
  def order(column)
    title ||= Chouette::Line.human_attribute_name(column).titleize  
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil  
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    link_to title, { :sort => column, :direction => direction}, {:class => css_class}
  end
end
