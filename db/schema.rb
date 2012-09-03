# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120830095442) do

  create_table "access_links", :force => true do |t|
    t.integer  "access_point_id",                        :limit => 8
    t.integer  "stop_area_id",                           :limit => 8
    t.string   "objectid",                                                                           :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",                                       :precision => 19, :scale => 2
    t.boolean  "lift_availability"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.time     "default_duration"
    t.time     "frequent_traveller_duration"
    t.time     "occasional_traveller_duration"
    t.time     "mobility_restricted_traveller_duration"
    t.string   "link_type"
    t.integer  "int_user_needs"
    t.string   "link_orientation"
  end

  add_index "access_links", ["objectid"], :name => "access_links_objectid_key", :unique => true

  create_table "access_points", :force => true do |t|
    t.string   "objectid"
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "longitude",                       :precision => 19, :scale => 16
    t.decimal  "latitude",                        :precision => 19, :scale => 16
    t.string   "long_lat_type"
    t.decimal  "x",                               :precision => 19, :scale => 2
    t.decimal  "y",                               :precision => 19, :scale => 2
    t.string   "projection_type"
    t.string   "country_code"
    t.string   "street_name"
    t.string   "contained_in"
    t.datetime "openning_time"
    t.datetime "closing_time"
    t.string   "type"
    t.boolean  "lift_availability"
    t.datetime "mobility_restricted_suitability"
    t.datetime "stairs_availability"
  end

  add_index "access_points", ["objectid"], :name => "access_points_objectid_key", :unique => true

  create_table "companies", :force => true do |t|
    t.string   "objectid",                  :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "short_name"
    t.string   "organizational_unit"
    t.string   "operating_department_name"
    t.string   "code"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "registration_number"
  end

  add_index "companies", ["objectid"], :name => "companies_objectid_key", :unique => true
  add_index "companies", ["registration_number"], :name => "companies_registration_number_key", :unique => true

  create_table "connection_links", :force => true do |t|
    t.integer  "departure_id",                           :limit => 8
    t.integer  "arrival_id",                             :limit => 8
    t.string   "objectid",                                                                           :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",                                       :precision => 19, :scale => 2
    t.string   "link_type"
    t.time     "default_duration"
    t.time     "frequent_traveller_duration"
    t.time     "occasional_traveller_duration"
    t.time     "mobility_restricted_traveller_duration"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.boolean  "lift_availability"
    t.integer  "int_user_needs"
  end

  add_index "connection_links", ["objectid"], :name => "connection_links_objectid_key", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "export_log_messages", :force => true do |t|
    t.integer  "export_id"
    t.string   "key"
    t.string   "arguments",  :limit => 1000
    t.integer  "position"
    t.string   "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "export_log_messages", ["export_id"], :name => "index_export_log_messages_on_export_id"

  create_table "exports", :force => true do |t|
    t.integer  "referential_id"
    t.string   "status"
    t.string   "type"
    t.string   "options"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "references_type"
    t.string   "reference_ids"
  end

  add_index "exports", ["referential_id"], :name => "index_exports_on_referential_id"

  create_table "facilities", :force => true do |t|
    t.integer  "stop_area_id",       :limit => 8
    t.integer  "line_id",            :limit => 8
    t.integer  "connection_link_id", :limit => 8
    t.integer  "stop_point_id",      :limit => 8
    t.string   "objectid",                                                        :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "description"
    t.boolean  "free_access"
    t.decimal  "longitude",                       :precision => 19, :scale => 16
    t.decimal  "latitude",                        :precision => 19, :scale => 16
    t.string   "long_lat_type"
    t.decimal  "x",                               :precision => 19, :scale => 2
    t.decimal  "y",                               :precision => 19, :scale => 2
    t.string   "projection_type"
    t.string   "country_code"
    t.string   "street_name"
    t.string   "contained_in"
  end

  add_index "facilities", ["objectid"], :name => "facilities_objectid_key", :unique => true

  create_table "facilities_features", :id => false, :force => true do |t|
    t.integer "facility_id", :limit => 8
    t.integer "choice_code"
  end

  add_index "facilities_features", ["facility_id"], :name => "idx_facility_id"

  create_table "file_validation_log_messages", :force => true do |t|
    t.integer  "file_validation_id"
    t.string   "key"
    t.string   "arguments",          :limit => 1000
    t.integer  "position"
    t.string   "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "file_validation_log_messages", ["file_validation_id"], :name => "index_file_validation_log_messages_on_file_validation_id"

  create_table "file_validations", :force => true do |t|
    t.string   "status"
    t.string   "options",    :limit => 2000
    t.string   "file_name"
    t.string   "file_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_of_lines", :force => true do |t|
    t.string   "objectid",       :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
  end

  add_index "group_of_lines", ["objectid"], :name => "group_of_lines_objectid_key", :unique => true

  create_table "group_of_lines_lines", :id => false, :force => true do |t|
    t.integer "group_of_line_id", :limit => 8, :null => false
    t.integer "line_id",          :limit => 8, :null => false
  end

  add_index "group_of_lines_lines", ["group_of_line_id"], :name => "idx_grli_gr"
  add_index "group_of_lines_lines", ["line_id"], :name => "idx_grli_li"

  create_table "import_log_messages", :force => true do |t|
    t.integer  "import_id"
    t.string   "key"
    t.string   "arguments",  :limit => 1000
    t.integer  "position"
    t.string   "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_log_messages", ["import_id"], :name => "index_import_log_messages_on_import_id"

  create_table "imports", :force => true do |t|
    t.integer  "referential_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "options"
    t.string   "file_type"
  end

  add_index "imports", ["referential_id"], :name => "index_imports_on_referential_id"

  create_table "journey_patterns", :force => true do |t|
    t.integer  "route_id",                :limit => 8
    t.string   "objectid",                             :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "registration_number"
    t.string   "published_name"
    t.integer  "departure_stop_point_id", :limit => 8
    t.integer  "arrival_stop_point_id",   :limit => 8
  end

  add_index "journey_patterns", ["objectid"], :name => "journey_patterns_objectid_key", :unique => true

  create_table "journey_patterns_stop_points", :id => false, :force => true do |t|
    t.integer "journey_pattern_id", :limit => 8, :null => false
    t.integer "stop_point_id",      :limit => 8, :null => false
  end

  add_index "journey_patterns_stop_points", ["journey_pattern_id"], :name => "idx_jpsp_jpid"
  add_index "journey_patterns_stop_points", ["journey_pattern_id"], :name => "index_journey_pattern_id_on_journey_patterns_stop_points"

  create_table "lines", :force => true do |t|
    t.integer  "network_id",                      :limit => 8
    t.integer  "company_id",                      :limit => 8
    t.string   "objectid",                                     :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "number"
    t.string   "published_name"
    t.string   "transport_mode_name"
    t.string   "registration_number"
    t.string   "comment"
    t.boolean  "mobility_restricted_suitability"
    t.integer  "int_user_needs"
  end

  add_index "lines", ["objectid"], :name => "lines_objectid_key", :unique => true
  add_index "lines", ["registration_number"], :name => "lines_registration_number_key", :unique => true

  create_table "networks", :force => true do |t|
    t.string   "objectid",            :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.date     "version_date"
    t.string   "description"
    t.string   "name"
    t.string   "registration_number"
    t.string   "source_name"
    t.string   "source_type"
    t.string   "source_identifier"
    t.string   "comment"
  end

  add_index "networks", ["objectid"], :name => "networks_objectid_key", :unique => true
  add_index "networks", ["registration_number"], :name => "networks_registration_number_key", :unique => true

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pt_links", :force => true do |t|
    t.integer  "start_of_link_id", :limit => 8
    t.integer  "end_of_link_id",   :limit => 8
    t.integer  "route_id",         :limit => 8
    t.string   "objectid",                                                     :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",                 :precision => 19, :scale => 2
  end

  add_index "pt_links", ["objectid"], :name => "pt_links_objectid_key", :unique => true

  create_table "referentials", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix"
    t.string   "projection_type"
    t.string   "bounding_box",    :limit => nil
    t.string   "time_zone"
    t.string   "bounds"
    t.integer  "organisation_id"
  end

  create_table "routes", :force => true do |t|
    t.integer  "line_id",           :limit => 8
    t.string   "objectid",                       :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.integer  "opposite_route_id", :limit => 8
    t.string   "published_name"
    t.string   "number"
    t.string   "direction"
    t.string   "wayback"
  end

  add_index "routes", ["objectid"], :name => "routes_objectid_key", :unique => true

  create_table "routing_constraints_lines", :id => false, :force => true do |t|
    t.integer "stop_area_id", :limit => 8
    t.integer "line_id",      :limit => 8
  end

  add_index "routing_constraints_lines", ["line_id"], :name => "idx_rcli_li"
  add_index "routing_constraints_lines", ["stop_area_id"], :name => "idx_rcli_st"

  create_table "stop_areas", :force => true do |t|
    t.integer  "parent_id",           :limit => 8
    t.string   "objectid",                                                         :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "area_type"
    t.string   "registration_number"
    t.string   "nearest_topic_name"
    t.integer  "fare_code"
    t.decimal  "longitude",                        :precision => 19, :scale => 16
    t.decimal  "latitude",                         :precision => 19, :scale => 16
    t.string   "long_lat_type"
    t.decimal  "x",                                :precision => 19, :scale => 2
    t.decimal  "y",                                :precision => 19, :scale => 2
    t.string   "projection_type"
    t.string   "country_code"
    t.string   "street_name"
  end

  add_index "stop_areas", ["objectid"], :name => "stop_areas_objectid_key", :unique => true
  add_index "stop_areas", ["parent_id"], :name => "index_stop_areas_on_parent_id"

  create_table "stop_areas_stop_areas", :id => false, :force => true do |t|
    t.integer "child_id",  :limit => 8
    t.integer "parent_id", :limit => 8
  end

  create_table "stop_points", :force => true do |t|
    t.integer  "route_id",       :limit => 8
    t.integer  "stop_area_id",   :limit => 8
    t.string   "objectid",                    :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.integer  "position"
  end

  add_index "stop_points", ["objectid"], :name => "stop_points_objectid_key", :unique => true

  create_table "time_slots", :force => true do |t|
    t.string   "objectid",                     :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.time     "beginning_slot_time"
    t.time     "end_slot_time"
    t.time     "first_departure_time_in_slot"
    t.time     "last_departure_time_in_slot"
  end

  add_index "time_slots", ["objectid"], :name => "time_slots_objectid_key", :unique => true

  create_table "time_table_dates", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "date"
    t.integer "position",                   :null => false
  end

  add_index "time_table_dates", ["time_table_id"], :name => "index_time_table_dates_on_time_table_id"

  create_table "time_table_periods", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "period_start"
    t.date    "period_end"
    t.integer "position",                   :null => false
  end

  add_index "time_table_periods", ["time_table_id"], :name => "index_time_table_periods_on_time_table_id"

  create_table "time_tables", :force => true do |t|
    t.string   "objectid",                      :null => false
    t.integer  "object_version", :default => 1
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "version"
    t.string   "comment"
    t.integer  "int_day_types",  :default => 0
  end

  add_index "time_tables", ["objectid"], :name => "time_tables_objectid_key", :unique => true

  create_table "time_tables_vehicle_journeys", :id => false, :force => true do |t|
    t.integer "time_table_id",      :limit => 8, :null => false
    t.integer "vehicle_journey_id", :limit => 8, :null => false
  end

  add_index "time_tables_vehicle_journeys", ["time_table_id"], :name => "index_time_tables_vehicle_journeys_on_time_table_id"
  add_index "time_tables_vehicle_journeys", ["vehicle_journey_id"], :name => "index_time_tables_vehicle_journeys_on_vehicle_journey_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vehicle_journey_at_stops", :force => true do |t|
    t.integer "vehicle_journey_id",             :limit => 8
    t.integer "stop_point_id",                  :limit => 8
    t.string  "connecting_service_id"
    t.string  "boarding_alighting_possibility"
    t.time    "arrival_time"
    t.time    "departure_time"
    t.time    "waiting_time"
    t.time    "elapse_duration"
    t.time    "headway_frequency"
    t.integer "position",                       :limit => 8
    t.boolean "is_departure",                                :default => false
    t.boolean "is_arrival",                                  :default => false
  end

  add_index "vehicle_journey_at_stops", ["stop_point_id"], :name => "index_vehicle_journey_at_stops_on_stop_point_id"
  add_index "vehicle_journey_at_stops", ["stop_point_id"], :name => "index_vehicle_journey_at_stops_on_stop_pointid"
  add_index "vehicle_journey_at_stops", ["vehicle_journey_id"], :name => "index_vehicle_journey_at_stops_on_vehicle_journey_id"

  create_table "vehicle_journeys", :force => true do |t|
    t.integer  "route_id",                     :limit => 8
    t.integer  "journey_pattern_id",           :limit => 8
    t.integer  "time_slot_id",                 :limit => 8
    t.integer  "company_id",                   :limit => 8
    t.string   "objectid",                                  :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "comment"
    t.string   "status_value"
    t.string   "transport_mode"
    t.string   "published_journey_name"
    t.string   "published_journey_identifier"
    t.string   "facility"
    t.string   "vehicle_type_identifier"
    t.integer  "number"
  end

  add_index "vehicle_journeys", ["objectid"], :name => "vehicle_journeys_objectid_key", :unique => true
  add_index "vehicle_journeys", ["route_id"], :name => "index_vehicle_journeys_on_route_id"

end
