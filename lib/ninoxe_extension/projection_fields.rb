  
  module NinoxeExtension::ProjectionFields 
    extend ActiveSupport::Concern

    included do
      attr_accessible :projection_x,:projection_y,:projection_xy
  
      # add projection_type set on pre-insert and pre_update action
    before_save :set_projections
    def set_projections
      if ! self.coordinates.blank?
        self.long_lat_type = 'WGS84'
      else
        self.long_lat_type = nil
      end
    end

    def projection
      if self.referential.projection_type.nil? || self.referential.projection_type.empty?
        nil
      else
        self.referential.projection_type
      end
    end
    @point = nil

    def projection_x
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        @point.x
      end
    end
    def projection_y
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        @point.y
      end
    end
    def projection_xy
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        @point.x.to_s+","+@point.y.to_s
      end
    end
    def projection_x=(dummy)
      # dummy method
    end
    def projection_y=(dummy)
      # dummy method
    end
    def projection_xy=(dummy)
      # dummy method
    end
    end
  end


