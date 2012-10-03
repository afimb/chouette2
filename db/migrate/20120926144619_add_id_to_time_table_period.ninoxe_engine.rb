# This migration comes from ninoxe_engine (originally 20120926141415)
class AddIdToTimeTablePeriod < ActiveRecord::Migration
  def change
    # active record can't add primary key after table creation
    # must do SQL direct command
    execute <<-SQL
       ALTER TABLE time_table_periods ADD COLUMN id bigserial
    SQL
    execute <<-SQL
       ALTER TABLE time_table_periods ADD CONSTRAINT time_table_periods_pkey PRIMARY KEY (id)
    SQL
  end
end
