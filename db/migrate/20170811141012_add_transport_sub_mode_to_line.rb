class AddTransportSubModeToLine < ActiveRecord::Migration[4.2]
  def change
    add_column :lines, :transport_submode_name, :string
  end
end
