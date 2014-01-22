# The model table must have two columns :
#   - references_type
#   - reference_ids
# The model class should also define
# cattr :references_types with expected classes for references_type
module TypeIdsModelable
  def self.included(base)
    base.extend(Methods)
  end

  def references
    if references_relation.present? and reference_ids.present?
      referential.send(references_relation).find(reference_ids)
    else
      []
    end
  end

  def references=(references)
    unless references.blank?
      self.references_type = references.first.class.name
      self.reference_ids = references.map(&:id)
    else
      self.references_type = nil
      self.reference_ids = []
    end
  end

  def references_relation
    if references_type.present?
      relation = self.class.references_relation(references_type)
      relation if referential.respond_to?(relation)
    end
  end

  def reference_ids
    if raw_reference_ids
      raw_reference_ids.split(',').map(&:to_i)
    else
      []
    end
  end

  def reference_ids=(records)
    records = Array(records)
    write_attribute :reference_ids, (records.present? ? records.join(',') : nil)
  end

  def raw_reference_ids
    read_attribute :reference_ids
  end

  module Methods
    def type_ids_modelable_class?
      return true
    end
    def references_relation(type)
      type.to_s.demodulize.underscore.pluralize
    end
  end
end
