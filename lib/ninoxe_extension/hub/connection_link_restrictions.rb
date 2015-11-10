# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module ConnectionLinkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |cl|
        # HUB-34
        cl.validates :link_distance, numericality: { less_than_or_equal_to: 10000.to_f }
      end
    end
  end
end

