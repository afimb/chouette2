class AddInterchangeIndex < ActiveRecord::Migration[5.2]
  def up
    # fix wrong index creation in 20170726135818_add_interchange,rb
    remove_index "interchanges", :name => "interchanges_to_vehicle_journey_key" if index_name_exists?(:interchanges, :interchanges_to_vehicle_journey_key)
    add_index "interchanges", ["to_vehicle_journey"], :name => "interchanges_to_vehicle_journey_idx"
  end

  def down
    remove_index "interchanges", :name => "interchanges_to_vehicle_journey_idx" if index_name_exists?(:interchanges, :interchanges_to_vehicle_journey_idx)
  end

end
