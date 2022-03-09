class Chouette::DestinationDisplayVia < ActiveRecord::Base
  belongs_to :destination_display, :class_name => "Chouette::DestinationDisplay"
  belongs_to :via, :class_name => "Chouette::DestinationDisplay"
  validate :validate_ids

  private
  def validate_ids
    errors.add("IDs", "cannot be the same.") unless destination_display_id != via_id
  end
end

