class AddDatedServiceJourneys < ActiveRecord::Migration
  def change
    create_table :dated_service_journeys, :force => true do |t|
      t.string   "objectid",                  null: false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.date  "operating_day", :null => false
      t.integer  "vehicle_journey_id", :null => false
      t.string   "service_alteration"
    end
    add_index "dated_service_journeys", ["objectid"], :name => "dated_service_journeys_objectid_key", :unique => true
    add_foreign_key "dated_service_journeys", "vehicle_journeys", name: "dated_service_journeys_vehicle_journey_id_fkey"

    create_table :dated_service_journey_refs, :id => false, :force => true do |t|
      t.integer  "original_dsj_id"
      t.integer  "derived_dsj_id"
    end
    add_index "dated_service_journey_refs", ["original_dsj_id", "derived_dsj_id"], :unique => true,
              :name => "dated_service_journey_refs_original_dsj_id_derived_dsj_id_key"
    add_index "dated_service_journey_refs", ["derived_dsj_id"], :name => "dated_service_journey_refs_derived_dsj_id_idx"
    add_foreign_key "dated_service_journey_refs", "dated_service_journeys", column: "original_dsj_id",  name: "dated_service_journey_refs_original_dsj_id_fkey"
    add_foreign_key "dated_service_journey_refs", "dated_service_journeys", column: "derived_dsj_id",  name: "dated_service_journey_refs_derived_dsj_id_fkey"

  end
end
