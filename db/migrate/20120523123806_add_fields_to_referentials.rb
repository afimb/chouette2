class AddFieldsToReferentials < ActiveRecord::Migration
  def change
        add_column :referentials, :prefix, :string
        add_column :referentials, :projection_type, :string
        add_column :referentials, :time_zone, :string
  end
end
