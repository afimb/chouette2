module ConnectionLinkRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions

    with_options if: Proc.new { |o| o.format_restricted?(:hub) } do |cl|
      # HUB-34
      cl.validates :link_distance, numericality: { less_than_or_equal_to: 10_000.to_f }
    end
  end
end

