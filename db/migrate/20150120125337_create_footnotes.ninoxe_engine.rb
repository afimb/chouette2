# This migration comes from ninoxe_engine (originally 20150115153453)
class CreateFootnotes < ActiveRecord::Migration[4.2]
  def change
    create_table :footnotes do |t|
      t.integer  "line_id", :limit => 8
      t.string :code
      t.string :label

      t.timestamps
    end
  end
end
