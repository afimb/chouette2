module ObjectidRestrictions
  extend ActiveSupport::Concern

  included do
    before_validation :default_values, on: :create
    before_save :set_object_version
    validates :codespace, presence: true
    validates :objectid, presence: true
    validates :objectid, uniqueness: { scope: :codespace }
    validates :object_version, numericality: true

    # HUB
    before_validation :hub_objectid?, if: Proc.new { |o| o.format_restricted?(:hub) }

    # NEPTUNE
    before_validation :neptune_objectid?, if: Proc.new { |o| o.format_restricted?(:neptune) }

    # GTFS
    before_validation :gtfs_objectid?, if: Proc.new { |o| o.format_restricted?(:gtfs) }

    # NETEX
    before_validation :netex_objectid?, if: Proc.new { |o| o.format_restricted?(:netex) }

    after_create :build_objectid
  end

  protected

  def default_values
    self.objectid = "__pending_id__#{Time.current.to_i + rand(1000)}" if self.objectid.blank?
    self.object_version ||= 1
    self.codespace = referential.prefix
    self.creator_id = 'chouette'
  end

  def set_object_version
    self.object_version = self.object_version.present? ? (self.object_version + 1) : 1
  end

  def build_objectid
    self.objectid = self.id
    fix_uniq_objectid
    self.update_attributes(objectid: self.objectid)
  end

  def fix_uniq_objectid
    self.valid?
    i = 1
    while self.errors[:codespace].present? || self.errors[:objectid].present?
      self.objectid << "_#{i}"
      self.valid?
      i += 1
    end
  end

  def netex_objectid?
    # Any word character (letter, number, underscore) AND dash
    check_by_format((self.objectid =~ /\A[\w-]*\z/) == 0)
  end

  def neptune_objectid?
    # Any word character (letter, number, underscore) AND dash
    check_by_format((self.objectid =~ /\A[\w-]*\z/) == 0)
  end

  def gtfs_objectid?
    # Any non-whitespace character
    check_by_format((self.objectid =~ /\A[\S]*\z/) == 0)
  end

  def hub_objectid?
    # Any non-whitespace character
    check_by_format((self.objectid =~ /\A[\S]*\z/) == 0)
  end

  def check_by_format(format_valid)
    format = caller_locations.first.label.split('_').first
    errors.add(:objectid, I18n.t("activerecord.errors.models.concerns.objectid.invalid_objectid.#{format}")) unless format_valid
    return format_valid
  end
end
