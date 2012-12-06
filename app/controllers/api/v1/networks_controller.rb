module Api
  module V1
    class NetworksController < ChouetteController
      inherit_resources

      defaults :resource_class => Chouette::Network, :finder => :find_by_objectid!
      
  protected

      def collection
        @networks ||= referential.networks
      end 
    end
  end
end

