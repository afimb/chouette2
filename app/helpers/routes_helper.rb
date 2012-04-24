module RoutesHelper
  def line_formatted_name( line)
    return line.publishedname if line.number.blank?
    "#{line.publishedname} [#{line.number}]"
  end
end

