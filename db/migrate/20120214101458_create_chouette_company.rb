class CreateChouetteCompany < ActiveRecord::Migration[4.2]
  def up
    create_table "companies", :force => true do |t|
      t.string   "objectid", :null => false
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
  end

  def down
  end
end
