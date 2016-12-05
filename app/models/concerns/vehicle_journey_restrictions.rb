module VehicleJourneyRestrictions
  extend ActiveSupport::Concern

  included do
    include ObjectidRestrictions
    def self.specific_objectid_size
      8
    end
  end
end
