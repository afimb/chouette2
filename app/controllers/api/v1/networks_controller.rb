module Api
  module V1
    class NetworksController < ChouetteController

      defaults :resource_class => Chouette::Network, :finder => :find_by_objectid!
      
  protected

      def collection
        @networks ||= ( @referential ? @referential.networks.search(params[:q]).result(:distinct => true) : [])
      end 
    end
  end
end

