module StopAreaHierarchyRestrictions
  extend ActiveSupport::Concern

  def possible_children
    case area_type
    when 'BoardingPosition', 'Quay', 'ZoneDEmbarquement', 'Stop'
      []
    else
      children = Chouette::AreaType.list_children(self.referential_format, self.area_type)
      return [] unless children&.any?
      Chouette::StopArea.where(area_type: children.map(&:camelize)) - [self]
    end
  end

  def possible_parents
    parents = Chouette::AreaType.list_parents(self.referential_format, self.area_type)
    return [] unless parents&.any?
    Chouette::StopArea.where(area_type: parents.map(&:camelize)) - [self]
  end

  def area_type_parents
    Chouette::AreaType.list_parents(self.referential_format, self.area_type)
  end

  def area_type_children
    Chouette::AreaType.list_children(self.referential_format, self.area_type)
  end
end
