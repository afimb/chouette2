module VehicleJourneyRestrictions
  extend ActiveSupport::Concern

  included do
    def self.specific_objectid_size
      8
    end
  end
end
