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

ActiveRecord::Schema.define(version: 20170911175632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "access_links", id: :bigserial, force: :cascade do |t|
    t.integer  "access_point_id",                        limit: 8
    t.integer  "stop_area_id",                           limit: 8
    t.string   "objectid",                                                                  null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",                                    precision: 19, scale: 2
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

  add_index "access_links", ["objectid"], name: "access_links_objectid_key", unique: true, using: :btree

  create_table "access_points", id: :bigserial, force: :cascade do |t|
    t.string   "objectid"
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "longitude",                                 precision: 19, scale: 16
    t.decimal  "latitude",                                  precision: 19, scale: 16
    t.string   "long_lat_type"
    t.string   "country_code"
    t.string   "street_name"
    t.string   "contained_in"
    t.time     "openning_time"
    t.time     "closing_time"
    t.string   "access_type"
    t.boolean  "lift_availability"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.integer  "stop_area_id",                    limit: 8
    t.string   "zip_code"
    t.string   "city_name"
  end

  add_index "access_points", ["objectid"], name: "access_points_objectid_key", unique: true, using: :btree

  create_table "api_keys", id: :bigserial, force: :cascade do |t|
    t.integer  "referential_id"
    t.string   "token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codespaces", id: :bigserial, force: :cascade do |t|
    t.string   "xmlns",      null: false
    t.string   "xmlns_url",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",                  null: false
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
    t.string   "url"
    t.string   "time_zone"
    t.string   "organisation_type"
    t.string   "legal_name"
    t.string   "public_email"
    t.string   "public_url"
    t.string   "public_phone"
  end

  add_index "companies", ["objectid"], name: "companies_objectid_key", unique: true, using: :btree
  add_index "companies", ["registration_number"], name: "companies_registration_number_key", using: :btree

  create_table "connection_links", id: :bigserial, force: :cascade do |t|
    t.integer  "departure_id",                           limit: 8
    t.integer  "arrival_id",                             limit: 8
    t.string   "objectid",                                                                  null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",                                    precision: 19, scale: 2
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

  add_index "connection_links", ["objectid"], name: "connection_links_objectid_key", unique: true, using: :btree

  create_table "delayed_jobs", id: :bigserial, force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "destination_display_via", id: false, force: :cascade do |t|
    t.integer  "destination_display_id", limit: 8, null: false
    t.integer  "via_id",                 limit: 8, null: false
    t.integer  "position",               limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "destination_display_via", ["destination_display_id"], name: "index_destination_display_id_on_destination_display_via", using: :btree

  create_table "destination_displays", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.string   "side_text"
    t.string   "front_text",               null: false
    t.string   "objectid",                 null: false
    t.integer  "object_version", limit: 8
    t.datetime "creation_time"
    t.string   "creator_id"
  end

  create_table "exports", id: :bigserial, force: :cascade do |t|
    t.integer  "referential_id",  limit: 8
    t.string   "status"
    t.string   "type"
    t.string   "options"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "references_type"
    t.string   "reference_ids"
  end

  add_index "exports", ["referential_id"], name: "index_exports_on_referential_id", using: :btree

  create_table "facilities", id: :bigserial, force: :cascade do |t|
    t.integer  "stop_area_id",       limit: 8
    t.integer  "line_id",            limit: 8
    t.integer  "connection_link_id", limit: 8
    t.integer  "stop_point_id",      limit: 8
    t.string   "objectid",                                               null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "description"
    t.boolean  "free_access"
    t.decimal  "longitude",                    precision: 19, scale: 16
    t.decimal  "latitude",                     precision: 19, scale: 16
    t.string   "long_lat_type"
    t.decimal  "x",                            precision: 19, scale: 2
    t.decimal  "y",                            precision: 19, scale: 2
    t.string   "projection_type"
    t.string   "country_code"
    t.string   "street_name"
    t.string   "contained_in"
  end

  add_index "facilities", ["objectid"], name: "facilities_objectid_key", unique: true, using: :btree

  create_table "facilities_features", id: false, force: :cascade do |t|
    t.integer "facility_id", limit: 8
    t.integer "choice_code"
  end

  create_table "footnotes", id: :bigserial, force: :cascade do |t|

    t.integer  "line_id",        limit: 8
    t.string   "code"
    t.string   "label"
    t.datetime "creation_time"
    t.string   "objectid",                 null: false
    t.integer  "object_version"
    t.string   "creator_id"
  end

  add_index "footnotes", ["objectid"], name: "footnotes_objectid_key", unique: true, using: :btree

  create_table "footnotes_journey_patterns", id: false, force: :cascade do |t|
    t.integer "journey_pattern_id"
    t.integer "footnote_id"
  end

  add_index "footnotes_journey_patterns", ["footnote_id"], name: "footnotes_id_journey_patterns_id_idx", using: :btree
  add_index "footnotes_journey_patterns", ["journey_pattern_id"], name: "footnotes_journey_patterns_id_idx", using: :btree

  create_table "footnotes_lines", id: false, force: :cascade do |t|
    t.integer "line_id"
    t.integer "footnote_id"
  end

  add_index "footnotes_lines", ["footnote_id"], name: "footnotes_footnote_line_id_idx", using: :btree
  add_index "footnotes_lines", ["line_id"], name: "footnotes_line_id_idx", using: :btree

  create_table "footnotes_stop_points", id: false, force: :cascade do |t|
    t.integer "stop_point_id"
    t.integer "footnote_id"
  end

  add_index "footnotes_stop_points", ["footnote_id"], name: "footnotes_stop_point_id_idx", using: :btree
  add_index "footnotes_stop_points", ["stop_point_id"], name: "stop_point_id_idx", using: :btree

  create_table "footnotes_vehicle_journey_at_stops", id: false, force: :cascade do |t|
    t.integer "vehicle_journey_at_stop_id"
    t.integer "footnote_id"
  end

  add_index "footnotes_vehicle_journey_at_stops", ["footnote_id"], name: "footnotes_vehicle_journey_at_stop_id_idx", using: :btree
  add_index "footnotes_vehicle_journey_at_stops", ["vehicle_journey_at_stop_id"], name: "vehicle_journey_at_stop_id_idx", using: :btree

  create_table "footnotes_vehicle_journeys", id: false, force: :cascade do |t|
    t.integer "vehicle_journey_id", limit: 8
    t.integer "footnote_id",        limit: 8
  end

  create_table "group_of_lines", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",            null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "registration_number"
  end

  add_index "group_of_lines", ["objectid"], name: "group_of_lines_objectid_key", unique: true, using: :btree

  create_table "group_of_lines_lines", id: false, force: :cascade do |t|
    t.integer "group_of_line_id", limit: 8
    t.integer "line_id",          limit: 8
  end

  create_table "interchanges", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",              null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.integer  "priority"
    t.boolean  "planned"
    t.boolean  "guaranteed"
    t.boolean  "advertised"
    t.time     "maximum_wait_time"
    t.string   "from_point"
    t.string   "to_point"
    t.string   "from_vehicle_journey"
    t.string   "to_vehicle_journey"
    t.boolean  "stay_seated"
    t.time     "minimum_transfer_time"
    t.integer  "from_visit_number"
    t.integer  "to_visit_number"
  end

  add_index "interchanges", ["from_vehicle_journey"], name: "interchanges_from_vehicle_journey_key", using: :btree
  add_index "interchanges", ["objectid"], name: "interchanges_objectid_key", unique: true, using: :btree
  add_index "interchanges", ["objectid"], name: "interchanges_to_vehicle_journey_key", using: :btree

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
    t.string   "objectid",                                      null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "registration_number"
    t.string   "published_name"
    t.integer  "departure_stop_point_id", limit: 8
    t.integer  "arrival_stop_point_id",   limit: 8
    t.integer  "section_status",                    default: 0, null: false
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
    t.string   "objectid",                                  null: false
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
    t.boolean  "flexible_service"
    t.string   "url"
    t.string   "color",                           limit: 6
    t.string   "text_color",                      limit: 6
    t.string   "stable_id"
    t.string   "transport_submode_name"
  end

  add_index "lines", ["objectid"], name: "lines_objectid_key", unique: true, using: :btree
  add_index "lines", ["registration_number"], name: "lines_registration_number_key", using: :btree

  create_table "networks", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",            null: false
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
    t.integer  "company_id"
  end

  add_index "networks", ["objectid"], name: "networks_objectid_key", unique: true, using: :btree
  add_index "networks", ["registration_number"], name: "networks_registration_number_key", using: :btree

  create_table "organisations", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_format", default: "neptune"
  end

  create_table "pt_links", id: :bigserial, force: :cascade do |t|
    t.integer  "start_of_link_id", limit: 8
    t.integer  "end_of_link_id",   limit: 8
    t.integer  "route_id",         limit: 8
    t.string   "objectid",                                            null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",              precision: 19, scale: 2
  end

  add_index "pt_links", ["objectid"], name: "pt_links_objectid_key", unique: true, using: :btree

  create_table "referentials", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix"
    t.string   "projection_type"
    t.string   "time_zone"
    t.string   "bounds"
    t.integer  "organisation_id",     limit: 8
    t.text     "geographical_bounds"
    t.integer  "user_id",             limit: 8
    t.string   "user_name"
    t.string   "data_format"
  end

  add_index "referentials", ["name", "organisation_id"], name: "index_referentials_on_name_and_organisation_id", unique: true, using: :btree

  create_table "route_sections", id: :bigserial, force: :cascade do |t|
    t.geometry "input_geometry",                   limit: {:srid=>4326, :type=>"line_string"}
    t.geometry "processed_geometry",               limit: {:srid=>4326, :type=>"line_string"}
    t.string   "objectid",                                                                                     null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.float    "distance"
    t.boolean  "no_processing",                                                                default: false, null: false
    t.string   "arrival_stop_area_objectid_key"
    t.string   "departure_stop_area_objectid_key"
  end

  add_index "route_sections", ["arrival_stop_area_objectid_key"], name: "index_route_sections_on_arrival_stop_area_objectid_key", using: :btree
  add_index "route_sections", ["departure_stop_area_objectid_key"], name: "index_route_sections_on_departure_stop_area_objectid_key", using: :btree
  add_index "route_sections", ["objectid"], name: "route_sections_objectid_key", unique: true, using: :btree

  create_table "routes", id: :bigserial, force: :cascade do |t|
    t.integer  "line_id",           limit: 8
    t.string   "objectid",                    null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.integer  "opposite_route_id", limit: 8
    t.string   "published_name"
    t.string   "number"
    t.string   "direction"
    t.string   "wayback"
  end

  add_index "routes", ["objectid"], name: "routes_objectid_key", unique: true, using: :btree

  create_table "routing_constraints_lines", id: false, force: :cascade do |t|
    t.integer "line_id",                limit: 8
    t.string  "stop_area_objectid_key"
  end

  add_index "routing_constraints_lines", ["stop_area_objectid_key"], name: "index_routing_constraints_lines_on_stop_area_objectid_key", using: :btree

  create_table "rule_parameter_sets", id: :bigserial, force: :cascade do |t|
    t.text     "parameters"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id", limit: 8
  end

  create_table "scheduled_stop_points", id: :bigserial, force: :cascade do |t|
    t.string   "objectid",                           null: false
    t.string   "stop_area_objectid_key"
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id",             limit: 255
    t.string   "name"
  end

  add_index "scheduled_stop_points", ["objectid"], name: "scheduled_stop_points_objectid_key", unique: true, using: :btree
  add_index "scheduled_stop_points", ["stop_area_objectid_key"], name: "scheduled_stop_points_stop_area_idx", using: :btree

  create_table "stop_areas", id: :bigserial, force: :cascade do |t|
    t.integer  "parent_id",                       limit: 8
    t.string   "objectid",                                                            null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.string   "area_type"
    t.string   "registration_number"
    t.string   "nearest_topic_name"
    t.integer  "fare_code"
    t.decimal  "longitude",                                 precision: 19, scale: 16
    t.decimal  "latitude",                                  precision: 19, scale: 16
    t.string   "long_lat_type"
    t.string   "country_code"
    t.string   "street_name"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.boolean  "lift_availability"
    t.integer  "int_user_needs"
    t.string   "zip_code"
    t.string   "city_name"
    t.string   "url"
    t.string   "time_zone"
    t.integer  "compass_bearing"
    t.string   "stop_place_type"
    t.string   "transport_mode"
    t.string   "transport_sub_mode"
  end

  add_index "stop_areas", ["name"], name: "index_stop_areas_on_name", using: :btree
  add_index "stop_areas", ["objectid"], name: "stop_areas_objectid_key", unique: true, using: :btree
  add_index "stop_areas", ["parent_id"], name: "index_stop_areas_on_parent_id", using: :btree
  add_index "stop_areas", ["stop_place_type"], name: "index_stop_areas_on_stop_place_type", using: :btree
  add_index "stop_areas", ["transport_mode"], name: "index_stop_areas_on_transport_mode", using: :btree
  add_index "stop_areas", ["transport_sub_mode"], name: "index_stop_areas_on_transport_sub_mode", using: :btree

  create_table "stop_areas_stop_areas", id: false, force: :cascade do |t|
    t.integer "child_id",  limit: 8
    t.integer "parent_id", limit: 8
  end

  create_table "stop_points", id: :bigserial, force: :cascade do |t|
    t.integer  "route_id",               limit: 8
    t.string   "objectid",                         null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.integer  "position"
    t.string   "for_boarding"
    t.string   "for_alighting"
    t.integer  "destination_display_id"
    t.integer  "scheduled_stop_point_id",           null: false
  end

  add_index "stop_points", ["objectid"], name: "stop_points_objectid_key", unique: true, using: :btree

  create_table "taggings", id: :bigserial, force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", id: :bigserial, force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
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
    t.string   "objectid",                   null: false
    t.integer  "object_version", default: 1
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "version"
    t.string   "comment"
    t.integer  "int_day_types",  default: 0
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
    t.string   "objectid",       null: false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.time     "start_time",     null: false
    t.time     "end_time",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
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
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "invitation_token"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "invitation_created_at"
    t.integer  "role",                   default: 1,  null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vehicle_journey_at_stops", id: :bigserial, force: :cascade do |t|
    t.integer "vehicle_journey_id",             limit: 8
    t.integer "stop_point_id",                  limit: 8
    t.string  "connecting_service_id"
    t.string  "boarding_alighting_possibility"
    t.time    "arrival_time"
    t.time    "departure_time"
    t.string  "for_boarding"
    t.string  "for_alighting"
    t.integer "arrival_day_offset",                       default: 0, null: false
    t.integer "departure_day_offset",                     default: 0, null: false
  end

  add_index "vehicle_journey_at_stops", ["stop_point_id"], name: "index_vehicle_journey_at_stops_on_stop_pointid", using: :btree
  add_index "vehicle_journey_at_stops", ["vehicle_journey_id"], name: "index_vehicle_journey_at_stops_on_vehicle_journey_id", using: :btree

  create_table "vehicle_journeys", id: :bigserial, force: :cascade do |t|
    t.integer  "route_id",                        limit: 8
    t.integer  "journey_pattern_id",              limit: 8
    t.integer  "company_id",                      limit: 8
    t.string   "objectid",                                              null: false
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
    t.integer  "number",                          limit: 8
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "flexible_service"
    t.integer  "journey_category",                          default: 0, null: false
    t.string   "transport_submode_name"
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
  add_foreign_key "journey_frequencies", "timebands"
  add_foreign_key "journey_frequencies", "vehicle_journeys"
  add_foreign_key "journey_pattern_sections", "journey_patterns"
  add_foreign_key "journey_pattern_sections", "route_sections"
  add_foreign_key "journey_patterns", "routes", name: "jp_route_fkey", on_delete: :cascade
  add_foreign_key "journey_patterns", "stop_points", column: "arrival_stop_point_id", name: "arrival_point_fkey", on_delete: :nullify
  add_foreign_key "journey_patterns", "stop_points", column: "departure_stop_point_id", name: "departure_point_fkey", on_delete: :nullify
  add_foreign_key "journey_patterns_stop_points", "journey_patterns", name: "jpsp_jp_fkey", on_delete: :cascade
  add_foreign_key "journey_patterns_stop_points", "stop_points", name: "jpsp_stoppoint_fkey", on_delete: :cascade
  add_foreign_key "lines", "companies", name: "line_company_fkey", on_delete: :nullify
  add_foreign_key "lines", "networks", name: "line_ptnetwork_fkey", on_delete: :nullify
  add_foreign_key "networks", "companies", name: "network_company_fkey", on_delete: :nullify
  add_foreign_key "routes", "lines", name: "route_line_fkey", on_delete: :cascade
  add_foreign_key "routes", "routes", column: "opposite_route_id", name: "route_opposite_route_fkey", on_delete: :nullify
  add_foreign_key "routing_constraints_lines", "lines", name: "routingconstraint_line_fkey", on_delete: :cascade
  add_foreign_key "stop_areas", "stop_areas", column: "parent_id", name: "area_parent_fkey", on_delete: :nullify
  add_foreign_key "stop_areas_stop_areas", "stop_areas", column: "child_id", name: "stoparea_child_fkey", on_delete: :cascade
  add_foreign_key "stop_areas_stop_areas", "stop_areas", column: "parent_id", name: "stoparea_parent_fkey", on_delete: :cascade
  add_foreign_key "stop_points", "destination_displays", name: "stop_point_destination_display_fkey"
  add_foreign_key "stop_points", "routes", name: "stoppoint_route_fkey", on_delete: :cascade
  add_foreign_key "stop_points", "scheduled_stop_points"
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
