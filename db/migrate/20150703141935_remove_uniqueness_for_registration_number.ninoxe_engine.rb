# This migration comes from ninoxe_engine (originally 20150630135517)
class RemoveUniquenessForRegistrationNumber < ActiveRecord::Migration[4.2]
  def up
    remove_index "lines", name: "lines_registration_number_key" if index_exists?(:lines, :registration_number, name: "lines_registration_number_key")
    add_index "lines", ["registration_number"], :name => "lines_registration_number_key"

    remove_index "companies", name: "companies_registration_number_key" if index_exists?(:companies, :registration_number, name: "companies_registration_number_key")
    add_index "companies", ["registration_number"], :name => "companies_registration_number_key"

    remove_index "networks", name: "networks_registration_number_key" if index_exists?(:networks, :registration_number, name: "networks_registration_number_key")
    add_index "networks", ["registration_number"], :name => "networks_registration_number_key"
  end
  def down
    remove_index "lines", name: "lines_registration_number_key" if index_exists?(:lines, :registration_number, name: "lines_registration_number_key")
    add_index "lines", ["registration_number"], :name => "lines_registration_number_key", :unique => true

    remove_index "companies", name: "companies_registration_number_key" if index_exists?(:companies, :registration_number, name: "companies_registration_number_key")
    add_index "companies", ["registration_number"], :name => "companies_registration_number_key", :unique => true

    remove_index "networks", name: "networks_registration_number_key" if index_exists?(:networks, :registration_number, name: "networks_registration_number_key")
    add_index "networks", ["registration_number"], :name => "networks_registration_number_key", :unique => true
  end
end
