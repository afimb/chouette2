class AddCodespaceAndSharedToTables < ActiveRecord::Migration
  def self.up
    list_tables.each do |t|
      add_column t, :codespace, :string, null: false, default: Referential.where(slug: Apartment::Tenant.current).first&.prefix, after: :objectid
      add_column t, :shared, :boolean, null: false, default: false, after: :codespace
      remove_index t, name: "#{t}_objectid_key" unless [:route_sections, :timebands, :routing_constraints].include?(t)
      remove_index t, :objectid if t == :routing_constraints
      add_index t, [:codespace, :objectid], unique: true
    end
  end

  def self.down
    list_tables.each do |t|
      remove_column t, :codespace
      remove_column t, :shared
      add_index t, :objectid, name: "#{t}_objectid_key" unless [:route_sections, :timebands, :routing_constraints].include?(t)
      add_index t, :objectid if t == :routing_constraints
    end
  end

  private

  def list_tables
    [
      :access_links,
      :access_points,
      :companies,
      :connection_links,
      :group_of_lines,
      :journey_patterns,
      :lines,
      :networks,
      :route_sections,
      :routing_constraints,
      :routes,
      :stop_areas,
      :stop_points,
      :time_tables,
      :timebands,
      :vehicle_journeys
    ]
  end
end
