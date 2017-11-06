module Chouette
  class RoutePoint < TridentActiveRecord

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :scheduled_stop_point

    validates_presence_of :scheduled_stop_point
    validate :scheduled_stop_point_id_validation

    accepts_nested_attributes_for :scheduled_stop_point
    has_one :stop_area, :through => :scheduled_stop_point

    def name
      if (self[:name])
        self[:name]
      elsif (scheduled_stop_point != nil && scheduled_stop_point.stop_area != nil)
        scheduled_stop_point.stop_area.name
      else
        ''
      end

    end

    def scheduled_stop_point_name
      if (scheduled_stop_point)
        scheduled_stop_point.name
      end
    end

    def scheduled_stop_point_name=(name)
      if (scheduled_stop_point)
        scheduled_stop_point.name = name
      end
    end

    def scheduled_stop_point_id_or_stop_area_objectid_key=(data)
      split=data.split(',')
      if (split.first && !split.first.empty?)
        self.scheduled_stop_point=Chouette::ScheduledStopPoint.find(split.first)
      else
        self.scheduled_stop_point= Chouette::ScheduledStopPoint.new(:stop_area_objectid_key => split.last)
      end
    end

    def self.area_candidates
      Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition'])
    end

    def scheduled_stop_point_id_validation
      if scheduled_stop_point.nil?
        errors.add(:scheduled_stop_point, I18n.t("errors.messages.empty"))
      end
    end

    def scheduled_stop_point_id_or_stop_area_objectid_key
      if (scheduled_stop_point_id || stop_area)
        if (stop_area)
          stop_area_objectid=stop_area.object_id
        end
        [scheduled_stop_point_id, stop_area_objectid].join(',')
      end
    end

  end
end
