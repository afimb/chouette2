class CreateReferentialLastUpdate < ActiveRecord::Migration[4.2]
  def up
    create_table "referential_last_update", :force => true do |t|
      t.datetime "last_update_timestamp"
    end
    execute("insert into referential_last_update(last_update_timestamp) values(current_timestamp)")


  end

  def down
    drop_table "referential_last_update"
  end
end
