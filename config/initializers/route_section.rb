Rails.application.config.to_prepare do
  Chouette::RouteSection.processor = Osrm_5_RouteSectionProcessor.new
end
