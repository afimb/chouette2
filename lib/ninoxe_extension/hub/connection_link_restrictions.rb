# -*- coding: utf-8 -*-
module NinoxeExtension::Hub
  module ConnectionLinkRestrictions
    extend ActiveSupport::Concern

    included do
      include ObjectidRestrictions

      with_options if: :hub_restricted? do |jp|
        # HUB-34
        jp.validates :link_distance, :numericality => { :max => 10000.0 }
      end
    end
  end
end

