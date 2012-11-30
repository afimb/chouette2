module Api
  module V1
    class NetworksController < ActionController::Base
      def networks
        @networks ||= referential.networks
      end 
      def network
        @network ||= networks.where( :objectid => params[:id])
      end

      def index
        respond_to do |format|
          format.json { render :json => networks }
          format.xml { render :xml => networks }
        end
      end
      def show
        respond_to do |format|
          format.json { render :json => network }
          format.xml { render :xml => network }
        end
      end
    end
  end
end

