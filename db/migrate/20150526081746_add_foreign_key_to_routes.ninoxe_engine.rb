# This migration comes from ninoxe_engine (originally 20150526075108)
class AddForeignKeyToRoutes < ActiveRecord::Migration
require "forwardable"
  def up
	 Chouette::Route.all.map do |route|
		if route.opposite_route_id.present? &&  !Chouette::Route.exists?(route.opposite_route_id) 
		     route.update_attributes :opposite_route_id => nil
		end
	 end
    change_table :routes do |t|
      if  @connection.foreign_keys(:routes).any? 
        @connection.foreign_keys(:routes).map do |f|
          name = f.options[:name]
          if (name == "route_opposite_route_fkey" )
            remove_foreign_key :routes, :name => name
          end
        end
      end
		t.foreign_key :routes, :dependent => :nullify, :column => 'opposite_route_id', :name => 'route_opposite_route_fkey'
    end
     
  end

  def down
    change_table :routes do |t|
      t.remove_foreign_key :name => :route_opposite_route_fkey
    end
  end
end
