# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module ConnectionLinkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |cl|
        # HUB-34
        cl.validates :link_distance, :numericality => { :max => 10000.0 }
      end
    end
  end
end

