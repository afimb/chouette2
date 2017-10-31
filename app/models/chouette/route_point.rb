module Chouette
  class RoutePoint < TridentActiveRecord

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :scheduled_stop_point


    acts_as_list :scope => :route, top_of_list: 0

    validates_presence_of :scheduled_stop_point
    validate :scheduled_stop_point_id_validation

    accepts_nested_attributes_for :scheduled_stop_point

    def name
      if (self[:name])
        self[:name]
      elsif (scheduled_stop_point != nil && scheduled_stop_point.stop_area != nil)
        scheduled_stop_point.stop_area.name
      else
        '?'
      end

    end

    def scheduled_stop_point_id_validation
      if scheduled_stop_point.nil?
        errors.add(:scheduled_stop_point, I18n.t("errors.messages.empty"))
      end
    end

    def self.area_candidates
      Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition'])
    end


  end
end
