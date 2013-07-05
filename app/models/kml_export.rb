class KmlExport < Export

  def export_options
    super.merge(:format => :kml)
  end

  def exporter
    exporter ||= ::Chouette::Kml::Exporter.new()
  end

end
