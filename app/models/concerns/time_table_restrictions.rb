module TimeTableRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions
    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |tt|
      # HUB-45
      tt.validates :comment, length: { maximum: 75 }, allow_blank: true
    end

    def self.specific_objectid_size
      6
    end
  end
end
