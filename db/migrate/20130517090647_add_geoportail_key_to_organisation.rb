class AddGeoportailKeyToOrganisation < ActiveRecord::Migration
  def change
    add_column "organisations", "geoportail_key", "string"
  end
end
