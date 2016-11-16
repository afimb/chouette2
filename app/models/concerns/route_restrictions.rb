module RouteRestrictions
  extend ActiveSupport::Concern

  included do
    # HUB-37
    validate :max_instance_limitation, :wayback_code_limitation, if: Proc.new { |o| o.format_restricted?(:hub) }

    # HUB-38
    validates_format_of :objectid, with: %r{\A\w+:\w+:([\w]{1,8}|__pending_id__\d+)\z}, if: Proc.new { |o| o.format_restricted?(:hub) }

    def wayback_code_limitation
      errors.add(:wayback_code, I18n.t('hub.routes.wayback_code_exclusive')) if line.routes.reject { |r| r.id == id }.map(&:wayback_code).include?(wayback_code)
    end

    def max_instance_limitation
      errors.add(:flash, I18n.t('hub.routes.max_by_line')) if 2 < line.routes.size
    end
  end
end
