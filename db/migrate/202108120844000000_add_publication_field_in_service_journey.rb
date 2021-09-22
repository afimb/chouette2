class AddPublicationFieldInServiceJourney < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :publication, :string
  end
end