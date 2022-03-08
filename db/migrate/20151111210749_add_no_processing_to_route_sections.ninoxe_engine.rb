# This migration comes from ninoxe_engine (originally 2015110517100832)
class AddNoProcessingToRouteSections < ActiveRecord::Migration[4.2]

  def change
    add_column :route_sections, :no_processing, :boolean
  end

end
