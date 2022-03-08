# This migration comes from ninoxe_engine (originally 20150921100000)
class AddDistanceToRouteSections < ActiveRecord::Migration[4.2]

  def change
    add_column "route_sections", "distance", "float"
  end

end
