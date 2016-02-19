Rails.application.config.to_prepare do
  Chouette::RouteSection.processor = OsrmRouteSectionProcessor.new
end
