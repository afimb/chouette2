class FixInconsistentSequenceIncrement < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       ALTER SEQUENCE routes_id_seq increment by 50;
    SQL
  end

  def down
    execute <<-SQL
       ALTER SEQUENCE routes_id_seq increment by 100;
    SQL
  end
end
