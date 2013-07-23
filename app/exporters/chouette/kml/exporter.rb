class Chouette::Kml::Exporter

  attr_reader :referential
  attr_reader :kml_export

  def initialize(referential, kml_export)
    @referential = referential
    @kml_export = kml_export
  end

  def lines(object, ids)
    if object == "network"
      ids.present? ? referential.networks.find( ids.split(",") ).collect(&:lines).flatten : referential.networks.collect(&:lines).flatten
    elsif object == "company"
      ids.present? ? referential.companies.find( ids.split(",") ).collect(&:lines).flatten : referential.companies.collect(&:lines).flatten
    elsif object == "line"
      ids.present? ? referential.lines.find( ids.split(",") ): referential.lines
    else
      referential.lines
    end
  end

  def export(zip_file_path, options = {})
    begin
      referential.switch

      FileUtils.rm(zip_file_path) if File.exists? zip_file_path

      kml_export.log_messages.create( :severity => "ok", :key => "EXPORT", :arguments => {"0" => "KML"})

      Dir.mktmpdir(nil, "/tmp"){ |temp_dir|

        lines_collected = lines( options[:o], options[:id] ).sort_by(&:name)
        Chouette::Kml::LineExporter.save( lines_collected, temp_dir, kml_export)

        routes = lines_collected.collect(&:routes).flatten.uniq.sort_by(&:name)
        Chouette::Kml::RouteExporter.save( routes, temp_dir, kml_export)

        journey_patterns = routes.map { |r| r.journey_patterns}.flatten
        Chouette::Kml::JourneyPatternExporter.save( journey_patterns, temp_dir, kml_export)

        stop_areas = lines_collected.collect(&:stop_areas).flatten.uniq.sort_by(&:name)
        Chouette::Kml::StopAreaExporter.save( stop_areas, temp_dir, kml_export, "Quay")

        commercial_stop_areas = lines_collected.collect(&:commercial_stop_areas).flatten.uniq.sort_by(&:name)
        Chouette::Kml::StopAreaExporter.save( commercial_stop_areas, temp_dir, kml_export, "CommercialStopPoint")

        if(options[:o].present?) # Add all objects
          stop_places = referential.stop_areas.stop_place.sort_by(&:name)
          Chouette::Kml::StopAreaExporter.save( stop_places, temp_dir, kml_export, "StopPlace")

          itls = referential.stop_areas.itl.sort_by(&:name)
          Chouette::Kml::StopAreaExporter.save( itls, temp_dir, kml_export, "ITL")

          connection_links = referential.connection_links.sort_by(&:name)
          Chouette::Kml::ConnectionLinkExporter.save( connection_links, temp_dir, kml_export)

          access_links = referential.access_links.sort_by(&:name)
          Chouette::Kml::AccessLinkExporter.save(access_links, temp_dir, kml_export)

          access_points = referential.access_points.sort_by(&:name)
          Chouette::Kml::AccessPointExporter.save(access_points, temp_dir, kml_export)

        end

        ::Zip::ZipFile.open(zip_file_path, ::Zip::ZipFile::CREATE) do |zipfile|
          Dir[File.join(temp_dir, '*.kml')].each do |f|
            zipfile.add(File.basename(f), f)
          end
        end
      }
    ensure
      # Always cleanup files
      #FileUtils.remove_entry(temp_directory)
    end
  end

end

