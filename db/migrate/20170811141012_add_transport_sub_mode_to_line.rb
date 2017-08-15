class AddTransportSubModeToLine < ActiveRecord::Migration
  def change
    add_column :lines, :transport_submode_name, :string
  end
end
