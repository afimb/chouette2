class Chouette::Kml::Exporter
  def export(file, options = {})
    if options.include?(:line)
      Chouette::Kml::LineExporter.new( options[:line]).tap do |line_exporter|
        line_exporter.save(file)
      end
    end
  end
end

