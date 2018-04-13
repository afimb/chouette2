class AddKeyValuesToLines < ActiveRecord::Migration
  def change
    create_table :lines_key_values, :id => false, :force => true do |t|
      t.integer  "line_id"
      t.string   "type_of_key"
      t.string   "key"
      t.string   "value"
    end

    add_foreign_key "lines_key_values", "lines", name: "lines_key_values_lines_fkey", on_delete: :cascade
  end
end
