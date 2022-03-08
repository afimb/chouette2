class AddGeoportailKeyToOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column "organisations", "geoportail_key", "string"
  end
end
