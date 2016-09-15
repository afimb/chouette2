# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160913121300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "access_links", id: :bigserial, force: :cascade do |t|
    t.integer  "access_point_id",                        limit: 8
    t.integer  "stop_area_id",                           limit: 8
    t.string   "objectid",                               limit: 255,                          null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                             limit: 255
    t.string   "name",                                   limit: 255
    t.string   "comment",                                limit: 255
    t.decimal  "link_distance",                                      precision: 19, scale: 2
    t.boolean  "lift_availability"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.time     "default_duration"
    t.time     "frequent_traveller_duration"
    t.time     "occasional_traveller_duration"
    t.time     "mobility_restricted_traveller_duration"
    t.string   "link_type",                              limit: 255
    t.integer  "int_user_needs"
    t.string   "link_orientation",                       limit: 255
  end

  add_index "access_links", ["objectid"], name: "access_links_objectid_key", unique: true, using: :btree

  create_table "access_points", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",                        limit: 255
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                      limit: 255
    t.string   "name",                            limit: 255
    t.string   "comment",                         limit: 255
    t.decimal  "longitude",                                   precision: 19, scale: 16
    t.decimal  "latitude",                                    precision: 19, scale: 16
    t.string   "long_lat_type",                   limit: 255
    t.string   "country_code",                    limit: 255
    t.string   "street_name",                     limit: 255
    t.string   "contained_in",                    limit: 255
    t.time     "openning_time"
    t.time     "closing_time"
    t.string   "access_type",                     limit: 255
    t.boolean  "lift_availability"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.integer  "stop_area_id",                    limit: 8
    t.string   "zip_code",                        limit: 255
    t.string   "city_name",                       limit: 255
  end

  add_index "access_points", ["objectid"], name: "access_points_objectid_key", unique: true, using: :btree

  create_table "api_keys", id: :bigserial, force: :cascade do |t|
    t.integer  "referential_id"
    t.string   "token",          limit: 255
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",                  limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                limit: 255
    t.string   "name",                      limit: 255
    t.string   "short_name",                limit: 255
    t.string   "organizational_unit",       limit: 255
    t.string   "operating_department_name", limit: 255
    t.string   "code",                      limit: 255
    t.string   "phone",                     limit: 255
    t.string   "fax",                       limit: 255
    t.string   "email",                     limit: 255
    t.string   "registration_number",       limit: 255
    t.string   "url",                       limit: 255
    t.string   "time_zone",                 limit: 255
  end

  add_index "companies", ["objectid"], name: "companies_objectid_key", unique: true, using: :btree
  add_index "companies", ["registration_number"], name: "companies_registration_number_key", using: :btree

  create_table "connection_links", id: :bigserial, force: :cascade do |t|
    t.integer  "departure_id",                           limit: 8
    t.integer  "arrival_id",                             limit: 8
    t.string   "objectid",                               limit: 255,                          null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                             limit: 255
    t.string   "name",                                   limit: 255
    t.string   "comment",                                limit: 255
    t.decimal  "link_distance",                                      precision: 19, scale: 2
    t.string   "link_type",                              limit: 255
    t.time     "default_duration"
    t.time     "frequent_traveller_duration"
    t.time     "occasional_traveller_duration"
    t.time     "mobility_restricted_traveller_duration"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.boolean  "lift_availability"
    t.integer  "int_user_needs"
  end

  add_index "connection_links", ["objectid"], name: "connection_links_objectid_key", unique: true, using: :btree

  create_table "delayed_jobs", id: :bigserial, force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exports", id: :bigserial, force: :cascade do |t|
    t.integer  "referential_id",  limit: 8
    t.string   "status",          limit: 255
    t.string   "type",            limit: 255
    t.string   "options",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "references_type", limit: 255
    t.string   "reference_ids",   limit: 255
  end

  add_index "exports", ["referential_id"], name: "index_exports_on_referential_id", using: :btree

  create_table "facilities", id: :bigserial, force: :cascade do |t|
    t.integer  "stop_area_id",       limit: 8
    t.integer  "line_id",            limit: 8
    t.integer  "connection_link_id", limit: 8
    t.integer  "stop_point_id",      limit: 8
    t.string   "objectid",           limit: 255,                           null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",         limit: 255
    t.string   "name",               limit: 255
    t.string   "comment",            limit: 255
    t.string   "description",        limit: 255
    t.boolean  "free_access"
    t.decimal  "longitude",                      precision: 19, scale: 16
    t.decimal  "latitude",                       precision: 19, scale: 16
    t.string   "long_lat_type",      limit: 255
    t.decimal  "x",                              precision: 19, scale: 2
    t.decimal  "y",                              precision: 19, scale: 2
    t.string   "projection_type",    limit: 255
    t.string   "country_code",       limit: 255
    t.string   "street_name",        limit: 255
    t.string   "contained_in",       limit: 255
  end

  add_index "facilities", ["objectid"], name: "facilities_objectid_key", unique: true, using: :btree

  create_table "facilities_features", id: false, force: :cascade do |t|
    t.integer "facility_id", limit: 8
    t.integer "choice_code"
  end

  create_table "footnotes", id: :bigserial, force: :cascade do |t|
    t.integer  "line_id",    limit: 8
    t.string   "code",       limit: 255
    t.string   "label",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnotes_vehicle_journeys", id: false, force: :cascade do |t|
    t.integer "vehicle_journey_id", limit: 8
    t.integer "footnote_id",        limit: 8
  end

  create_table "group_of_lines", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",            limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",          limit: 255
    t.string   "name",                limit: 255
    t.string   "comment",             limit: 255
    t.string   "registration_number", limit: 255
  end

  add_index "group_of_lines", ["objectid"], name: "group_of_lines_objectid_key", unique: true, using: :btree

  create_table "group_of_lines_lines", id: false, force: :cascade do |t|
    t.integer "group_of_line_id", limit: 8
    t.integer "line_id",          limit: 8
  end

  create_table "journey_frequencies", id: :bigserial, force: :cascade do |t|
    t.integer  "vehicle_journey_id",         limit: 8
    t.time     "scheduled_headway_interval",                           null: false
    t.time     "first_departure_time",                                 null: false
    t.time     "last_departure_time"
    t.boolean  "exact_time",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeband_id",                limit: 8
  end

  add_index "journey_frequencies", ["timeband_id"], name: "index_journey_frequencies_on_timeband_id", using: :btree
  add_index "journey_frequencies", ["vehicle_journey_id"], name: "index_journey_frequencies_on_vehicle_journey_id", using: :btree

  create_table "journey_pattern_sections", id: :bigserial, force: :cascade do |t|
    t.integer  "journey_pattern_id", limit: 8, null: false
    t.integer  "route_section_id",   limit: 8, null: false
    t.integer  "rank",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "journey_pattern_sections", ["journey_pattern_id", "route_section_id", "rank"], name: "index_jps_on_journey_pattern_id_and_route_section_id_and_rank", unique: true, using: :btree
  add_index "journey_pattern_sections", ["journey_pattern_id"], name: "index_journey_pattern_sections_on_journey_pattern_id", using: :btree
  add_index "journey_pattern_sections", ["route_section_id"], name: "index_journey_pattern_sections_on_route_section_id", using: :btree

  create_table "journey_patterns", id: :bigserial, force: :cascade do |t|
    t.integer  "route_id",                limit: 8
    t.string   "objectid",                limit: 255,             null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",              limit: 255
    t.string   "name",                    limit: 255
    t.string   "comment",                 limit: 255
    t.string   "registration_number",     limit: 255
    t.string   "published_name",          limit: 255
    t.integer  "departure_stop_point_id", limit: 8
    t.integer  "arrival_stop_point_id",   limit: 8
    t.integer  "section_status",                      default: 0, null: false
  end

  add_index "journey_patterns", ["objectid"], name: "journey_patterns_objectid_key", unique: true, using: :btree

  create_table "journey_patterns_stop_points", id: false, force: :cascade do |t|
    t.integer "journey_pattern_id", limit: 8
    t.integer "stop_point_id",      limit: 8
  end

  add_index "journey_patterns_stop_points", ["journey_pattern_id"], name: "index_journey_pattern_id_on_journey_patterns_stop_points", using: :btree

  create_table "lines", id: :bigserial, force: :cascade do |t|
    t.integer  "network_id",                      limit: 8
    t.integer  "company_id",                      limit: 8
    t.string   "objectid",                        limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                      limit: 255
    t.string   "name",                            limit: 255
    t.string   "number",                          limit: 255
    t.string   "published_name",                  limit: 255
    t.string   "transport_mode_name",             limit: 255
    t.string   "registration_number",             limit: 255
    t.string   "comment",                         limit: 255
    t.boolean  "mobility_restricted_suitability"
    t.integer  "int_user_needs"
    t.boolean  "flexible_service"
    t.string   "url",                             limit: 255
    t.string   "color",                           limit: 6
    t.string   "text_color",                      limit: 6
    t.string   "stable_id",                       limit: 255
  end

  add_index "lines", ["objectid"], name: "lines_objectid_key", unique: true, using: :btree
  add_index "lines", ["registration_number"], name: "lines_registration_number_key", using: :btree

  create_table "networks", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",            limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",          limit: 255
    t.date     "version_date"
    t.string   "description",         limit: 255
    t.string   "name",                limit: 255
    t.string   "registration_number", limit: 255
    t.string   "source_name",         limit: 255
    t.string   "source_type",         limit: 255
    t.string   "source_identifier",   limit: 255
    t.string   "comment",             limit: 255
  end

  add_index "networks", ["objectid"], name: "networks_objectid_key", unique: true, using: :btree
  add_index "networks", ["registration_number"], name: "networks_registration_number_key", using: :btree

  create_table "organisations", id: :bigserial, force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_format", limit: 255, default: "neptune"
  end

  create_table "pt_links", id: :bigserial, force: :cascade do |t|
    t.integer  "start_of_link_id", limit: 8
    t.integer  "end_of_link_id",   limit: 8
    t.integer  "route_id",         limit: 8
    t.string   "objectid",         limit: 255,                          null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",       limit: 255
    t.string   "name",             limit: 255
    t.string   "comment",          limit: 255
    t.decimal  "link_distance",                precision: 19, scale: 2
  end

  add_index "pt_links", ["objectid"], name: "pt_links_objectid_key", unique: true, using: :btree

  create_table "referentials", id: :bigserial, force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "slug",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix",              limit: 255
    t.string   "projection_type",     limit: 255
    t.string   "time_zone",           limit: 255
    t.string   "bounds",              limit: 255
    t.integer  "organisation_id",     limit: 8
    t.text     "geographical_bounds"
    t.integer  "user_id",             limit: 8
    t.string   "user_name",           limit: 255
    t.string   "data_format",         limit: 255
  end

  add_index "referentials", ["name", "organisation_id"], name: "index_referentials_on_name_and_organisation_id", unique: true, using: :btree

  create_table "route_sections", id: :bigserial, force: :cascade do |t|
    t.integer  "departure_id",       limit: 8
    t.integer  "arrival_id",         limit: 8
    t.string   "objectid",           limit: 255,                                                 null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",         limit: 255
    t.geometry "input_geometry",     limit: {:srid=>4326, :type=>"line_string"}
    t.geometry "processed_geometry", limit: {:srid=>4326, :type=>"line_string"}
    t.float    "distance"
    t.boolean  "no_processing",                                                  default: false, null: false
  end

  create_table "routes", id: :bigserial, force: :cascade do |t|
    t.integer  "line_id",           limit: 8
    t.string   "objectid",          limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",        limit: 255
    t.string   "name",              limit: 255
    t.string   "comment",           limit: 255
    t.integer  "opposite_route_id", limit: 8
    t.string   "published_name",    limit: 255
    t.string   "number",            limit: 255
    t.string   "direction",         limit: 255
    t.string   "wayback",           limit: 255
  end

  add_index "routes", ["objectid"], name: "routes_objectid_key", unique: true, using: :btree

  create_table "routing_constraints_lines", id: false, force: :cascade do |t|
    t.integer "stop_area_id", limit: 8
    t.integer "line_id",      limit: 8
  end

  create_table "rule_parameter_sets", id: :bigserial, force: :cascade do |t|
    t.text     "parameters"
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id", limit: 8
  end

  create_table "stats", id: :bigserial, force: :cascade do |t|
    t.string "action",      limit: 255
    t.date   "date"
    t.string "format",      limit: 255
    t.string "referential", limit: 255
  end

  create_table "stop_areas", id: :bigserial, force: :cascade do |t|
    t.integer  "parent_id",                       limit: 8
    t.string   "objectid",                        limit: 255,                           null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                      limit: 255
    t.string   "name",                            limit: 255
    t.string   "comment",                         limit: 255
    t.string   "area_type",                       limit: 255
    t.string   "registration_number",             limit: 255
    t.string   "nearest_topic_name",              limit: 255
    t.integer  "fare_code"
    t.decimal  "longitude",                                   precision: 19, scale: 16
    t.decimal  "latitude",                                    precision: 19, scale: 16
    t.string   "long_lat_type",                   limit: 255
    t.string   "country_code",                    limit: 255
    t.string   "street_name",                     limit: 255
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.boolean  "lift_availability"
    t.integer  "int_user_needs"
    t.string   "zip_code",                        limit: 255
    t.string   "city_name",                       limit: 255
    t.string   "url",                             limit: 255
    t.string   "time_zone",                       limit: 255
  end

  add_index "stop_areas", ["objectid"], name: "stop_areas_objectid_key", unique: true, using: :btree
  add_index "stop_areas", ["parent_id"], name: "index_stop_areas_on_parent_id", using: :btree

  create_table "stop_areas_stop_areas", id: false, force: :cascade do |t|
    t.integer "child_id",  limit: 8
    t.integer "parent_id", limit: 8
  end

  create_table "stop_points", id: :bigserial, force: :cascade do |t|
    t.integer  "route_id",       limit: 8
    t.integer  "stop_area_id",   limit: 8
    t.string   "objectid",       limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",     limit: 255
    t.integer  "position"
    t.string   "for_boarding",   limit: 255
    t.string   "for_alighting",  limit: 255
  end

  add_index "stop_points", ["objectid"], name: "stop_points_objectid_key", unique: true, using: :btree

  create_table "taggings", id: :bigserial, force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", id: :bigserial, force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "time_table_dates", id: :bigserial, force: :cascade do |t|
    t.integer "time_table_id", limit: 8, null: false
    t.date    "date"
    t.integer "position",                null: false
    t.boolean "in_out"
  end

  add_index "time_table_dates", ["time_table_id"], name: "index_time_table_dates_on_time_table_id", using: :btree

  create_table "time_table_periods", id: :bigserial, force: :cascade do |t|
    t.integer "time_table_id", limit: 8, null: false
    t.date    "period_start"
    t.date    "period_end"
    t.integer "position",                null: false
  end

  add_index "time_table_periods", ["time_table_id"], name: "index_time_table_periods_on_time_table_id", using: :btree

  create_table "time_tables", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",       limit: 255,             null: false
    t.integer  "object_version",             default: 1
    t.datetime "creation_time"
    t.string   "creator_id",     limit: 255
    t.string   "version",        limit: 255
    t.string   "comment",        limit: 255
    t.integer  "int_day_types",              default: 0
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "time_tables", ["objectid"], name: "time_tables_objectid_key", unique: true, using: :btree

  create_table "time_tables_vehicle_journeys", id: false, force: :cascade do |t|
    t.integer "time_table_id",      limit: 8
    t.integer "vehicle_journey_id", limit: 8
  end

  add_index "time_tables_vehicle_journeys", ["time_table_id"], name: "index_time_tables_vehicle_journeys_on_time_table_id", using: :btree
  add_index "time_tables_vehicle_journeys", ["vehicle_journey_id"], name: "index_time_tables_vehicle_journeys_on_vehicle_journey_id", using: :btree

  create_table "timebands", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",       limit: 255, null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",     limit: 255
    t.string   "name",           limit: 255
    t.time     "start_time",                 null: false
    t.time     "end_time",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id"
    t.string   "name",                   limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "authentication_token",   limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.datetime "invitation_created_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vehicle_journey_at_stops", id: :bigserial, force: :cascade do |t|
    t.integer "vehicle_journey_id",             limit: 8
    t.integer "stop_point_id",                  limit: 8
    t.string  "connecting_service_id",          limit: 255
    t.string  "boarding_alighting_possibility", limit: 255
    t.time    "arrival_time"
    t.time    "departure_time"
    t.string  "for_boarding",                   limit: 255
    t.string  "for_alighting",                  limit: 255
    t.integer "arrival_day_offset",                         default: 0, null: false
    t.integer "departure_day_offset",                       default: 0, null: false
  end

  add_index "vehicle_journey_at_stops", ["stop_point_id"], name: "index_vehicle_journey_at_stops_on_stop_pointid", using: :btree
  add_index "vehicle_journey_at_stops", ["vehicle_journey_id"], name: "index_vehicle_journey_at_stops_on_vehicle_journey_id", using: :btree

  create_table "vehicle_journeys", id: :bigserial, force: :cascade do |t|
    t.integer  "route_id",                        limit: 8
    t.integer  "journey_pattern_id",              limit: 8
    t.integer  "company_id",                      limit: 8
    t.string   "objectid",                        limit: 255,             null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",                      limit: 255
    t.string   "comment",                         limit: 255
    t.string   "status_value",                    limit: 255
    t.string   "transport_mode",                  limit: 255
    t.string   "published_journey_name",          limit: 255
    t.string   "published_journey_identifier",    limit: 255
    t.string   "facility",                        limit: 255
    t.string   "vehicle_type_identifier",         limit: 255
    t.integer  "number",                          limit: 8
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "flexible_service"
    t.integer  "journey_category",                            default: 0, null: false
  end

  add_index "vehicle_journeys", ["objectid"], name: "vehicle_journeys_objectid_key", unique: true, using: :btree
  add_index "vehicle_journeys", ["route_id"], name: "index_vehicle_journeys_on_route_id", using: :btree

  add_foreign_key "access_links", "access_points", name: "aclk_acpt_fkey", on_delete: :cascade
  add_foreign_key "access_links", "stop_areas", name: "aclk_area_fkey", on_delete: :cascade
  add_foreign_key "access_points", "stop_areas", name: "access_area_fkey", on_delete: :cascade
  add_foreign_key "connection_links", "stop_areas", column: "arrival_id", name: "colk_endarea_fkey", on_delete: :cascade
  add_foreign_key "connection_links", "stop_areas", column: "departure_id", name: "colk_startarea_fkey", on_delete: :cascade
  add_foreign_key "group_of_lines_lines", "group_of_lines", name: "groupofline_group_fkey", on_delete: :cascade
  add_foreign_key "group_of_lines_lines", "lines", name: "groupofline_line_fkey", on_delete: :cascade
  add_foreign_key "journey_frequencies", "timebands", name: "journey_frequencies_timeband_id_fk", on_delete: :nullify
  add_foreign_key "journey_frequencies", "vehicle_journeys", name: "journey_frequencies_vehicle_journey_id_fk", on_delete: :nullify
  add_foreign_key "journey_pattern_sections", "journey_patterns", name: "journey_pattern_sections_journey_pattern_id_fk", on_delete: :cascade
  add_foreign_key "journey_pattern_sections", "route_sections", name: "journey_pattern_sections_route_section_id_fk", on_delete: :cascade
  add_foreign_key "journey_patterns", "routes", name: "jp_route_fkey", on_delete: :cascade
  add_foreign_key "journey_patterns", "stop_points", column: "arrival_stop_point_id", name: "arrival_point_fkey", on_delete: :nullify
  add_foreign_key "journey_patterns", "stop_points", column: "departure_stop_point_id", name: "departure_point_fkey", on_delete: :nullify
  add_foreign_key "journey_patterns_stop_points", "journey_patterns", name: "jpsp_jp_fkey", on_delete: :cascade
  add_foreign_key "journey_patterns_stop_points", "stop_points", name: "jpsp_stoppoint_fkey", on_delete: :cascade
  add_foreign_key "lines", "companies", name: "line_company_fkey", on_delete: :nullify
  add_foreign_key "lines", "networks", name: "line_ptnetwork_fkey", on_delete: :nullify
  add_foreign_key "route_sections", "stop_areas", column: "arrival_id", name: "route_sections_arrival_id_fk", on_delete: :cascade
  add_foreign_key "route_sections", "stop_areas", column: "departure_id", name: "route_sections_departure_id_fk", on_delete: :cascade
  add_foreign_key "routes", "lines", name: "route_line_fkey", on_delete: :cascade
  add_foreign_key "routes", "routes", column: "opposite_route_id", name: "route_opposite_route_fkey", on_delete: :nullify
  add_foreign_key "routing_constraints_lines", "lines", name: "routingconstraint_line_fkey", on_delete: :cascade
  add_foreign_key "routing_constraints_lines", "stop_areas", name: "routingconstraint_stoparea_fkey", on_delete: :cascade
  add_foreign_key "stop_areas", "stop_areas", column: "parent_id", name: "area_parent_fkey", on_delete: :nullify
  add_foreign_key "stop_areas_stop_areas", "stop_areas", column: "child_id", name: "stoparea_child_fkey", on_delete: :cascade
  add_foreign_key "stop_areas_stop_areas", "stop_areas", column: "parent_id", name: "stoparea_parent_fkey", on_delete: :cascade
  add_foreign_key "stop_points", "routes", name: "stoppoint_route_fkey", on_delete: :cascade
  add_foreign_key "stop_points", "stop_areas", name: "stoppoint_area_fkey"
  add_foreign_key "time_table_dates", "time_tables", name: "tm_date_fkey", on_delete: :cascade
  add_foreign_key "time_table_periods", "time_tables", name: "tm_period_fkey", on_delete: :cascade
  add_foreign_key "time_tables_vehicle_journeys", "time_tables", name: "vjtm_tm_fkey", on_delete: :cascade
  add_foreign_key "time_tables_vehicle_journeys", "vehicle_journeys", name: "vjtm_vj_fkey", on_delete: :cascade
  add_foreign_key "vehicle_journey_at_stops", "stop_points", name: "vjas_sp_fkey", on_delete: :cascade
  add_foreign_key "vehicle_journey_at_stops", "vehicle_journeys", name: "vjas_vj_fkey", on_delete: :cascade
  add_foreign_key "vehicle_journeys", "companies", name: "vj_company_fkey", on_delete: :nullify
  add_foreign_key "vehicle_journeys", "journey_patterns", name: "vj_jp_fkey", on_delete: :cascade
  add_foreign_key "vehicle_journeys", "routes", name: "vj_route_fkey", on_delete: :cascade
end
