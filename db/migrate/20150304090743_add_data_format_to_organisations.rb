class AddDataFormatToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :data_format, :string
  end
end
