class LinkFootnotesToLines < ActiveRecord::Migration[4.2]
  def change
    create_table :footnotes_lines, :id => false, :force => true do |t|
      t.integer  "line_id"
      t.integer  "footnote_id"
    end
    add_index "footnotes_lines", ["line_id"], :name => "footnotes_line_id_idx"
    add_index "footnotes_lines", ["footnote_id"], :name => "footnotes_footnote_line_id_idx"
  end
end
