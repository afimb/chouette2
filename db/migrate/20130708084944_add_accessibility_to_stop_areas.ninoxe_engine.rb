# This migration comes from ninoxe_engine (originally 20130708081951)
class AddAccessibilityToStopAreas < ActiveRecord::Migration[4.2]
  def up
    unless column_exists? :stop_areas, :mobility_restricted_suitability
      add_column :stop_areas, :mobility_restricted_suitability, :boolean
    end
    unless column_exists? :stop_areas, :stairs_availability
      add_column :stop_areas, :stairs_availability, :boolean
    end
    unless column_exists? :stop_areas, :lift_availability
      add_column :stop_areas, :lift_availability, :boolean
    end
    unless column_exists? :stop_areas, :int_user_needs
      add_column :stop_areas, :int_user_needs, :integer
    end
  end
  def down
    if column_exists? :stop_areas, :mobility_restricted_suitability
      remove_column :stop_areas, :mobility_restricted_suitability
    end
    if column_exists? :stop_areas, :stairs_availability
      remove_column :stop_areas, :stairs_availability
    end
    if column_exists? :stop_areas, :lift_availability
      remove_column :stop_areas, :lift_availability
    end
    if column_exists? :stop_areas, :int_user_needs
      remove_column :stop_areas, :int_user_needs
    end
  end
end
