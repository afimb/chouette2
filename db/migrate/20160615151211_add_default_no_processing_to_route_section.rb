class AddDefaultNoProcessingToRouteSection < ActiveRecord::Migration
  def self.up
    change_column :route_sections, :no_processing, :boolean, null: false, default: false
  end

  def self.down
    change_column :route_sections, :no_processing, :boolean, null: true, default: nil
  end
end
