class Chouette::Kml::Exporter 

  def initialize(referential)
    @referential = referential
  end

  def lines(object, ids)
    if object == "network"
      Chouette::Network.find( ids ).collect(&:lines)
    elsif object == "company"
      Chouette::Company.find( ids ).collect(&:lines)
    elsif object == "line"
      Chouette::Line.find( ids ).to_a
    else
      []
    end    
  end

  def export(zip_file_path, options = {})    
    begin       
      @referential.switch

      FileUtils.rm(zip_file_path) if File.exists? zip_file_path        

      Dir.mktmpdir{ |temp_dir|
        
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
        puts stop_areas.inspect
        Chouette::Kml::StopAreaExporter.new( stop_areas ).tap do |stop_area_exporter|
          stop_area_exporter.save(temp_dir, "stop_areas")
        end
        
        commercial_stop_areas = lines_collected.collect(&:commercial_stop_areas).flatten.uniq
        Chouette::Kml::StopAreaExporter.new( commercial_stop_areas ).tap do |stop_area_exporter|
          stop_area_exporter.save(temp_dir, "commercial_stop_areas")
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

