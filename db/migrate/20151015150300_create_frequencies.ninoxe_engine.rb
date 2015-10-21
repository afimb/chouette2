# This migration comes from ninoxe_engine (originally 20151015143707)
class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
      t.references :vehicle_journey, index: true
      t.time :scheduled_headway_interval, null: false
      t.time :first_departure_time, null: false
      t.time :last_departure_time
      t.boolean :exact_time, default: false

      t.timestamps
    end
  end
end
