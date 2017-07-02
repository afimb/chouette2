class Chouette::DestinationDisplayVia < ActiveRecord::Base
  belongs_to :destination_display, :class_name => Chouette::DestinationDisplay
  belongs_to :via, :class_name => Chouette::DestinationDisplay
end

