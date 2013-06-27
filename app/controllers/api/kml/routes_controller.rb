module Api
  module Kml
    class RoutesController < ChouetteController
      respond_to :kml

      defaults :resource_class => Chouette::Route

      belongs_to :referential do
        belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
      end
      
    protected

      alias_method :route, :resource

      def collection
        @routes ||= parent.routes
      end
    end
  end
end
