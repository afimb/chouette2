class AddPublicationFieldInServiceJourney < ActiveRecord::Migration[4.2]
  def change
    add_column :vehicle_journeys, :publication, :string
  end
end