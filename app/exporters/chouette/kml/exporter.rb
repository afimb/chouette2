class Chouette::Kml::Exporter

  require 'zip'
  
  attr_reader :referential
  attr_reader :kml_export, :lines, :routes, :journey_patterns

  def initialize(referential, kml_export)
    @referential = referential
    @kml_export = kml_export
    @lines = nil
    @routes = nil
    @journey_patterns = nil
  end

  def select_lines(object, ids)
    if object == "network"
      ids.present? ? Chouette::Line.includes(:routes).where( :network_id => ids.split(",")).order(:name) :
                     Chouette::Line.joins(:network).includes(:routes).order(:name)
    elsif object == "company"
      ids.present? ? Chouette::Line.includes(:routes).where( :company_id => ids.split(",")).order(:name) :
                     Chouette::Line.joins(:company).includes(:routes).order(:name)
    elsif object == "line" && ids.present?
      Chouette::Line.includes(:routes).where( :id => ids.split(",")).order(:name)
    else
      Chouette::Line.includes(:routes).order(:name)
    end
  end

  def routes_exportable?
    routes && routes.size < 150
  end

  def lines_exportable?
    lines && lines.size < 150
  end

  def journey_patterns_exportable?
    journey_patterns && journey_patterns.size < 150
  end

  def log_overflow_warning( target_class)
    kml_export.log_messages.create( :severity => "warning", :key => "EXPORT_ERROR|EXCEPTION",
                    :arguments => {"0" => I18n.t( 'export_log_messages.messages.overflow',
                    :count => 150, :data => target_class.model_name.human.pluralize)})
  end

  def export(zip_file_path, options = {})
    begin
      referential.switch

      FileUtils.rm(zip_file_path) if File.exists? zip_file_path

      kml_export.log_messages.create( :severity => "ok", :key => "EXPORT", :arguments => {"0" => "KML"})

      Dir.mktmpdir(nil, "/tmp"){ |temp_dir|

        @lines = select_lines( options[:o], options[:id] )
        @routes = lines.map(&:routes).flatten.sort {|a,b| (a.name && b.name) ? a.name <=> b.name : a.id <=> b.id} if lines_exportable?
        @journey_patterns = Chouette::JourneyPattern.where( :route_id => routes.map(&:id) ).order(:name) if routes_exportable?

        if lines_exportable?
          Chouette::Kml::LineExporter.save( lines, temp_dir, kml_export)
        else
          log_overflow_warning(Chouette::Line)
        end

        if routes_exportable?
          Chouette::Kml::RouteExporter.save( routes, temp_dir, kml_export)
        else
          log_overflow_warning(Chouette::Route) if lines_exportable?
        end

        if journey_patterns_exportable?
          Chouette::Kml::JourneyPatternExporter.save( journey_patterns, temp_dir, kml_export)
        else
          log_overflow_warning(Chouette::JourneyPattern) if routes_exportable?
        end

        # if too many lines
        # there may be too many stop_areas
        if lines_exportable?
          stop_areas = Chouette::StopArea.joins( :stop_points => [:route => :line]).where(:lines => {:id => lines.map(&:id)}).uniq.order(:name)
          Chouette::Kml::StopAreaExporter.save( stop_areas, temp_dir, kml_export, "Quay")

          commercial_stop_areas = Chouette::StopArea.where( :id => stop_areas.map(&:parent_id).compact.uniq).order(:name)
          Chouette::Kml::StopAreaExporter.save( commercial_stop_areas, temp_dir, kml_export, "CommercialStopPoint")
        end

        if( options[:o] == "line" and not options[:id].present?) # Add all objects
          stop_places = referential.stop_areas.stop_place.order(:name)
          Chouette::Kml::StopAreaExporter.save( stop_places, temp_dir, kml_export, "StopPlace")

          itls = referential.stop_areas.itl.order(:name)
          Chouette::Kml::StopAreaExporter.save( itls, temp_dir, kml_export, "ITL")

          connection_links = referential.connection_links.order(:name)
          Chouette::Kml::ConnectionLinkExporter.save( connection_links, temp_dir, kml_export)

          access_links = referential.access_links.order(:name)
          Chouette::Kml::AccessLinkExporter.save(access_links, temp_dir, kml_export)

          access_points = referential.access_points.order(:name)
          Chouette::Kml::AccessPointExporter.save(access_points, temp_dir, kml_export)

        end

        ::Zip::File.open(zip_file_path, ::Zip::File::CREATE) do |zipfile|
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

