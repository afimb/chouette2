module Chouette
  class TimebandValidator < ActiveModel::Validator
    def validate(record)
      if record.end_time <= record.start_time
        record.errors[:end_time] << I18n.t('activerecord.errors.models.timeband.start_must_be_before_end')
      end
    end
  end

  class Timeband < ::ApplicationRecord
    include ObjectidRestrictions
    self.primary_key = "id"

    validates :start_time, :end_time, presence: true
    validates_with TimebandValidator

    default_scope { order(:start_time) }

    def self.object_id_key
      "Timeband"
    end

    def fullname
      fullname = "#{I18n.l(self.start_time, format: :hour)}-#{I18n.l(self.end_time, format: :hour)}"
      "#{self.name} (#{fullname})" if self.name
    end

  end

end
