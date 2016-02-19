class RouteSectionSearch
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :departure_name, :arrival_name, :line_id
  attr_accessor :scope

  def scope
    scope ||= Chouette::RouteSection
  end

  def initialize(attributes = {})
    attributes.each { |k,v| send "#{k}=", v } if attributes
  end

  def collection()
    Rails.logger.debug "Search RouteSections with #{inspect}"
    collection = scope

    [:departure, :arrival].each do |endpoint|
      endpoint_name = send "#{endpoint}_name"
      collection = collection.by_endpoint_name(endpoint, endpoint_name) if endpoint_name.present?
    end

    collection = collection.by_line_id(line_id) if line_id.present?

    collection
  end

  def persisted?
    false
  end

end
