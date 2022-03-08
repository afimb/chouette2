class AddTheGeomToReferential < ActiveRecord::Migration[4.2]
  
  change_table :referentials do |t|
    t.string :bounds
  end
  
end
