class CreateChouetteGroupOfLineLine < ActiveRecord::Migration[4.2]
  def up
    create_table :group_of_lines_lines, :id => false, :force => true do |t|
      t.integer  "group_of_line_id", :limit => 8
      t.integer  "line_id",        :limit => 8
    end
  end

  def down
    drop_table :group_of_lines_lines
  end
end
