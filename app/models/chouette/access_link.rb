module Chouette
  class AccessLink < TridentActiveRecord
    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    attr_accessor :access_link_type, :link_orientation_type, :link_key

    belongs_to :access_point, :class_name => 'Chouette::AccessPoint'
    belongs_to :stop_area, :class_name => 'Chouette::StopArea'

    validates_presence_of :name
    validates_presence_of :link_orientation

    def self.nullable_attributes
      [:link_distance, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration,
        :mobility_restricted_traveller_duration, :link_type]
    end

    def access_link_type
      link_type && Chouette::ConnectionLinkType.new(link_type.underscore)
    end

    def access_link_type=(access_link_type)
      self.link_type = (access_link_type ? access_link_type.camelcase : nil)
    end

    @@access_link_types = nil
    def self.access_link_types
      @@access_link_types ||= Chouette::ConnectionLinkType.all
    end

    def link_orientation_type
      link_orientation && Chouette::LinkOrientationType.new(link_orientation.underscore)
    end

    def link_orientation_type=(link_orientation_type)
      self.link_orientation = (link_orientation_type ? link_orientation_type.camelcase : nil)
    end

    @@link_orientation_types = nil
    def self.link_orientation_types
      @@link_orientation_types ||= Chouette::LinkOrientationType.all
    end

    def geometry
      GeoRuby::SimpleFeatures::LineString.from_points( [ access_point.geometry, stop_area.geometry], 4326) if access_point.geometry and stop_area.geometry
    end

    def link_key
      Chouette::AccessLink.build_link_key(access_point,stop_area,link_orientation_type)
    end
    
    def self.build_link_key(access_point,stop_area,link_orientation_type)
      if link_orientation_type == "access_point_to_stop_area"
        "A_#{access_point.id}-S_#{stop_area.id}"
      else  
        "S_#{stop_area.id}-A_#{access_point.id}"
      end
    end

    def geometry_presenter
      Chouette::Geometry::AccessLinkPresenter.new self
    end
  end
end
