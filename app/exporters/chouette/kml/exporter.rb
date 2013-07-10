class Chouette::Kml::Exporter 

  attr_reader :referential

  def initialize(referential)
    @referential = referential
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

      Dir.mktmpdir(nil, "/tmp"){ |temp_dir|
        
        lines_collected = lines( options[:o], options[:id] )
        lines_collected.each do |line|
          Chouette::Kml::LineExporter.new( line ).tap do |line_exporter|
            line_exporter.save(temp_dir)
          end
        end
        
        routes = lines_collected.collect(&:routes).flatten.uniq
        routes.each do |route|
          Chouette::Kml::RouteExporter.new( route ).tap do |route_exporter|
            route_exporter.save(temp_dir)
          end
        end
        
        stop_areas = lines_collected.collect(&:stop_areas).flatten.uniq
        Chouette::Kml::StopAreaExporter.new( stop_areas ).tap do |stop_area_exporter|
          stop_area_exporter.save(temp_dir, "stop_areas")
        end
        
        commercial_stop_areas = lines_collected.collect(&:commercial_stop_areas).flatten.uniq
        Chouette::Kml::StopAreaExporter.new( commercial_stop_areas ).tap do |stop_area_exporter|
          stop_area_exporter.save(temp_dir, "commercial_stop_areas")
        end      
      
        if(options[:o].present?) # Add all objects
          stop_places = referential.stop_areas.stop_place
          Chouette::Kml::StopAreaExporter.new( stop_places ).tap do |stop_area_exporter|
            stop_area_exporter.save(temp_dir, "stop_places")
          end

          itls = referential.stop_areas.itl
          Chouette::Kml::StopAreaExporter.new( itls ).tap do |stop_area_exporter|
            stop_area_exporter.save(temp_dir, "itls")
          end
          
          connection_links = referential.connection_links
          Chouette::Kml::ConnectionLinkExporter.new( connection_links ).tap do |connection_link_exporter|
            connection_link_exporter.save(temp_dir)
          end

          access_links = referential.access_links
          Chouette::Kml::AccessLinkExporter.new( access_links ).tap do |access_link_exporter|
            access_link_exporter.save(temp_dir)
          end

          access_points = referential.access_points
          Chouette::Kml::AccessPointExporter.new( access_points ).tap do |access_point_exporter|
            access_point_exporter.save(temp_dir)
          end
          
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

