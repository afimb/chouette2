class AddRouteSectionUniqueObjectidIdx < ActiveRecord::Migration
  def change
    add_index "route_sections", ["objectid"], :name => "route_sections_objectid_key", :unique => true
  end
end
