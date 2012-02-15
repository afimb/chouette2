class CreateChouetteCompany < ActiveRecord::Migration
  def up
    create_table "company", :force => true do |t|
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.string   "name"
      t.string   "shortname"
      t.string   "organizationalunit"
      t.string   "operatingdepartmentname"
      t.string   "code"
      t.string   "phone"
      t.string   "fax"
      t.string   "email"
      t.string   "registrationnumber"
    end

    add_index "company", ["objectid"], :name => "company_objectid_key", :unique => true
    add_index "company", ["registrationnumber"], :name => "company_registrationnumber_key", :unique => true
  end

  def down
  end
end
