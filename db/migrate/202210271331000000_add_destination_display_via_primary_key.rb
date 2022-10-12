class AddDestinationDisplayViaPrimaryKey < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE destination_display_via ADD PRIMARY KEY (destination_display_id, via_id,position);"
  end
  def down
    execute "ALTER TABLE destination_display_via DROP CONSTRAINT destination_display_via_pkey;"
  end

end