class RemoveTransportModeParameterSet < ActiveRecord::Migration[4.2]
  def up
    if table_exists? :transport_mode_parameter_sets
      drop_table :transport_mode_parameter_sets
    end
  end

  def down
    unless table_exists? :transport_mode_parameter_sets
      create_table :transport_mode_parameter_sets do |a|
        a.belongs_to :rule_parameter_set  ,:limit => 8
        a.string :transport_mode
        a.text :parameters
        a.timestamps
      end
    end
  end
end
