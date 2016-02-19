module Api
  module V1
    class ChouetteController < ActionController::Base
      inherit_resources
      respond_to :json, :xml
      layout false
      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @referential = Api::V1::ApiKey.referential_from_token(token)

          @api_key = @referential.api_keys.find_by_token(token) if @referential
          switch_referential if @api_key
        end
      end
      def switch_referential
        Apartment::Tenant.switch!(@api_key.referential.slug)
      end 

    end
  end
end
