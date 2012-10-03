# This migration comes from ninoxe_engine (originally 20120926141405)
class AddIdToTimeTableDate < ActiveRecord::Migration
  def change
    # active record can't add primary key after table creation
    # must do SQL direct command
    execute <<-SQL
       ALTER TABLE time_table_dates ADD COLUMN id bigserial
    SQL
    execute <<-SQL
       ALTER TABLE time_table_dates ADD CONSTRAINT time_table_dates_pkey PRIMARY KEY (id)
    SQL
  end
end
