module ObjectidRestrictions
  extend ActiveSupport::Concern

  included do
    # HUB 1
    validate :third_part_objectid_uniqueness, if: Proc.new { |o| o.format_restricted?(:hub) }
    validate :validate_specific_objectid, if: Proc.new { |o| o.format_restricted?(:hub) }
  end

  def validate_specific_objectid
    return unless defined? self.class.specific_objectid_size
    if third_part_objectid.nil? || (!third_part_objectid.include?("_pending_") && third_part_objectid.size > self.class.specific_objectid_size)
      errors.add(:objectid, I18n.t('hub.invalid'))
    end
  end

  def third_part_objectid
    return nil if (%r{\A\w+:\w+:[0-9A-Za-z_-]+\z}).match(self.objectid).nil?
    self.objectid.match(/:([0-9A-Za-z_-]+)\z/)[1]
  end

  def third_part_objectid_uniqueness
    return true unless third_part_objectid
    likes = self.class.where( "objectid LIKE ?", "%:#{self.third_part_objectid}" )
    likes.size.zero? || ( likes.size==1 && likes.first.id==self.id)
  end
end

