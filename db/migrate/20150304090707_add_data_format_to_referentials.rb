class AddDataFormatToReferentials < ActiveRecord::Migration
  def change
    add_column :referentials, :data_format, :string
  end
end
