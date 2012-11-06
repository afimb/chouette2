module Api
  module V1
    class NetworksController < ActionController::Base
      respond_to :json, :xml
      layout false
      before_filter :restrict_access

      def referential
        @referential ||= organisation.referentials.find @referential_id
      end 
      def organisation
        @organisation ||= Organisation.find @organisation_id
      end 
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
      
private
      def restrict_access
        parse_key
        head :unauthorized unless organisation && referential
      end
      def parse_key
        @organisation_id, @referential_id = params[:access_token].split('-')
        switch_referential
      end
      def switch_referential
        Apartment::Database.switch(referential.slug)
      end 
      
    end
  end
end

