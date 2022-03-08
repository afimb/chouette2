class AddFieldsToReferentials < ActiveRecord::Migration[4.2]
  def change
        add_column :referentials, :prefix, :string
        add_column :referentials, :projection_type, :string
        add_column :referentials, :time_zone, :string
  end
end
