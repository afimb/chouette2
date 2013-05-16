# This migration comes from ninoxe_engine (originally 20130410143542)
class ResizeChouetteColumns < ActiveRecord::Migration
  def change
    change_column "vehicle_journeys", "number", "integer", {:limit => 8}
  end
end
