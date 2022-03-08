class AddDataFormatToOrganisations < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :data_format, :string
  end
end
