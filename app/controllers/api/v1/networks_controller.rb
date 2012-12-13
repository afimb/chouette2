module Api
  module V1
    class NetworksController < ChouetteController
      inherit_resources

      defaults :resource_class => Chouette::Network, :finder => :find_by_objectid!
      belongs_to :referential, :parent_class => ::Referential
      
  protected

      def parent
        @referential ||= Referential.find(params[:referential_id])
      end
      def collection
        @networks ||= referential.networks.search(params[:q]).result(:distinct => true)
      end 
    end
  end
end

