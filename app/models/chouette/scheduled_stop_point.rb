module Chouette
  class ScheduledStopPoint < TridentActiveRecord
    self.primary_key = "id"

    has_and_belongs_to_many :stop_points, :class_name => 'Chouette::StopPoint'
    belongs_to :stop_area, class_name: 'Chouette::StopArea', :primary_key => "objectid", :foreign_key => "stop_area_objectid_key"
    has_many :stop_points
    validates_presence_of :stop_area
    validate :stop_area_id_validation

    def stop_area_id_validation
      if stop_area_objectid_key.nil?
        errors.add(:stop_area_objectid_key, I18n.t("errors.messages.empty"))
      end
    end

    def self.area_candidates
      Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition'])
    end

    def scheduled_stop_point_id_or_stop_area_objectid_key
      if (id || stop_area_objectid_key)
        [id, stop_area_objectid_key].join(',')
      end
    end

  end
end
