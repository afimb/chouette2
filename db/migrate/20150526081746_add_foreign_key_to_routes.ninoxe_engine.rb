# This migration comes from ninoxe_engine (originally 20150526075108)
class AddForeignKeyToRoutes < ActiveRecord::Migration[4.2]
require "forwardable"
  def up
	 Chouette::Route.all.map do |route|
		if route.opposite_route_id.present? &&  !Chouette::Route.exists?(route.opposite_route_id)
		     route.update_attributes :opposite_route_id => nil
		end
	 end
   add_foreign_key :routes, :routes, on_delete: :nullify, column: 'opposite_route_id', name: 'route_opposite_route_fkey'
  end

  def down
    remove_foreign_key :routes, name: :route_opposite_route_fkey
  end
end
