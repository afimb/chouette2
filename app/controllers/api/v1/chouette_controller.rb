module Api
  module V1
    class ChouetteController < ActionController::Base
      respond_to :json, :xml
      layout false
      before_filter :restrict_access_and_switch

      def referential
        @referential ||= organisation.referentials.find_by_id @referential_id
      end 
      def organisation
        @organisation ||= Organisation.find_by_id @organisation_id
      end 

private
      def restrict_access_and_switch
        authenticate_or_request_with_http_token do |token, options|
          switch_referential if key_exists?( token)
        end
      end
      def key_exists?( token)
        @organisation_id, @referential_id = token.split('-')
        organisation && referential
      end
      def switch_referential
        Apartment::Database.switch(referential.slug)
      end 

    end
  end
end
