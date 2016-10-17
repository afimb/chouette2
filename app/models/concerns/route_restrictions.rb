module RouteRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions
    validate :max_instance_limitation, :wayback_code_limitation

    # HUB-37
    def wayback_code_limitation
      return unless hub_restricted?
      errors.add( :wayback_code, I18n.t('hub.routes.wayback_code_exclusive')) if line.routes.reject {|r| r.id==id}.map(&:wayback_code).include?( wayback_code)
    end

    # HUB-37
    def max_instance_limitation
      return unless hub_restricted?
      errors.add( :flash, I18n.t('hub.routes.max_by_line')) if 2 < line.routes.size
    end

    # HUB-38
    with_options if: :hub_restricted? do |route|
      route.validates_format_of :objectid, :with => %r{\A\w+:\w+:([\w]{1,8}|__pending_id__\d+)\z}
    end
  end
end
