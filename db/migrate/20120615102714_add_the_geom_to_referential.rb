class AddTheGeomToReferential < ActiveRecord::Migration
  
  change_table :referentials do |t|
    t.string :bounds
  end
  
end
