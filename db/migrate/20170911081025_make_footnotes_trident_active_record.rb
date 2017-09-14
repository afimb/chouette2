class MakeFootnotesTridentActiveRecord < ActiveRecord::Migration
  def change
    add_column :footnotes, :objectid, :string
    add_column :footnotes, :object_version, :integer
    add_column :footnotes, :creator_id, :string
    rename_column :footnotes, :created_at, :creation_time
    remove_column :footnotes, :updated_at
    remove_column :footnotes, :line_id
    execute <<-SQL
      update footnotes set object_version = 1, objectid = concat('XXX:Notice:',id)
    SQL
    change_column :footnotes, :objectid, :string, null: false
    add_index "footnotes", ["objectid"], :name => "footnotes_objectid_key", :unique => true

  end
end
