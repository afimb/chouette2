class AddDataFormatToReferentials < ActiveRecord::Migration[4.2]
  def change
    add_column :referentials, :data_format, :string
  end
end
