module Chouette
  class RoutingConstraint < Chouette::TridentActiveRecord
    validates :name, presence: true
    validates :objectid, presence: true, uniqueness: true
    has_and_belongs_to_many :lines, join_table: :routing_constraints_lines, dependent: :destroy
    has_and_belongs_to_many :stop_areas, dependent: :destroy

    def line_ids=(line_ids)
      lines = line_ids.split(',').uniq
      self.lines.clear
      Chouette::Line.find(lines).each do |line|
        self.lines << line
      end
    end

    def stop_area_ids=(stop_area_ids)
      stop_areas = stop_area_ids.split(',').uniq
      self.stop_areas.clear
      Chouette::StopArea.find(stop_areas).each do |stop|
        self.stop_areas << stop
      end
    end
  end
end