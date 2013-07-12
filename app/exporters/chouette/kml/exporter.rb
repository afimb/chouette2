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
        
        lines_collected = lines( options[:o], options[:id] )
        Chouette::Kml::LineExporter.save( lines_collected, temp_dir, kml_export)
        
        routes = lines_collected.collect(&:routes).flatten.uniq
        Chouette::Kml::RouteExporter.save( routes, temp_dir, kml_export)

        journey_patterns = routes.map { |r| r.journey_patterns}.flatten
        Chouette::Kml::JourneyPatternExporter.save( journey_patterns, temp_dir, kml_export)
        
        stop_areas = lines_collected.collect(&:stop_areas).flatten.uniq
        Chouette::Kml::StopAreaExporter.new( stop_areas, temp_dir ).tap do |stop_area_exporter|
          stop_area_exporter.save( "stop_areas")
        end
        kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|QUAY_AND_BOARDING_POSITION_COUNT", :arguments => {"0" => stop_areas.size})
        
        commercial_stop_areas = lines_collected.collect(&:commercial_stop_areas).flatten.uniq
        Chouette::Kml::StopAreaExporter.new( commercial_stop_areas, temp_dir ).tap do |stop_area_exporter|
          stop_area_exporter.save( "commercial_stop_areas")
        end      
        kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|COMMERCIAL_COUNT", :arguments => {"0" => commercial_stop_areas.size})
      
        if(options[:o].present?) # Add all objects
          stop_places = referential.stop_areas.stop_place
          Chouette::Kml::StopAreaExporter.new( stop_places, temp_dir ).tap do |stop_area_exporter|
            stop_area_exporter.save( "stop_places")
          end
          kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|STOP_PLACE_COUNT", :arguments => {"0" => stop_places.size})

          itls = referential.stop_areas.itl
          Chouette::Kml::StopAreaExporter.new( itls, temp_dir ).tap do |stop_area_exporter|
            stop_area_exporter.save( "itls")
          end
          kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|ITL_COUNT", :arguments => {"0" => itls.size})
          
          connection_links = referential.connection_links
          Chouette::Kml::ConnectionLinkExporter.save( connection_links, temp_dir, kml_export)

          access_links = referential.access_links
          Chouette::Kml::AccessLinkExporter.save(access_links, temp_dir, kml_export)

          access_points = referential.access_points
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

