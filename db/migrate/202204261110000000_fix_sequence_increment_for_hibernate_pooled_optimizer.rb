class FixSequenceIncrementForHibernatePooledOptimizer < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       ALTER SEQUENCE brandings_id_seq increment by 10;
       ALTER SEQUENCE codespaces_id_seq increment by 10;
       ALTER SEQUENCE companies_id_seq increment by 10;
       ALTER SEQUENCE destination_displays_id_seq increment by 10;
       ALTER SEQUENCE footnote_alternative_texts_id_seq increment by 10;
       ALTER SEQUENCE footnotes_id_seq increment by 10;
       ALTER SEQUENCE group_of_lines_id_seq increment by 10;
       ALTER SEQUENCE journey_patterns_id_seq increment by 20;
       ALTER SEQUENCE lines_id_seq increment by 10;
       ALTER SEQUENCE networks_id_seq increment by 10;

    SQL
  end

  def down
    execute <<-SQL
       ALTER SEQUENCE brandings_id_seq increment by 100;
       ALTER SEQUENCE codespaces_id_seq increment by 100;
       ALTER SEQUENCE companies_id_seq increment by 100;
       ALTER SEQUENCE destination_displays_id_seq increment by 100;
       ALTER SEQUENCE footnote_alternative_texts_id_seq increment by 100;
       ALTER SEQUENCE footnotes_id_seq increment by 100;
       ALTER SEQUENCE group_of_lines_id_seq increment by 100;
       ALTER SEQUENCE journey_patterns_id_seq increment by 100;
       ALTER SEQUENCE lines_id_seq increment by 100;
       ALTER SEQUENCE networks_id_seq increment by 100;
    SQL
  end
end
