require 'geokit'

class Chouette::PtLink < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  include Geokit::Mappable

  def geometry
    the_geom
  end

  def self.import_csv
    csv_file = Rails.root + "chouette_pt_links.csv"
    if File.exists?( csv_file)
      csv = CSV::Reader.parse(File.read(csv_file))

      slug = csv.shift.first

      Network::Base.find_by_slug( slug).tune_connection

      csv.each do |row|
        origin = Chouette::StopArea.find_by_objectid( row[0])
        destination = Chouette::StopArea.find_by_objectid( row[1])

        raise "unknown origin #{row[0]}" unless origin
        raise "unknown destination #{row[1]}" unless destination

        Chouette::PtLink.create( :departure_id => origin.id,
                                 :arrival_id => destination.id,
                                 :the_geom => GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb( row[2]))
      end
    end
    
  end

end
