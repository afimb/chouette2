module Api
  module V1
    class ChouetteController < ActionController::Base
      inherit_resources
      respond_to :json, :xml
      layout false
      before_filter :authenticate

      belongs_to :referential

private
      alias_method :referential, :parent

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @api_key = referential.api_keys.find_by_token(token)
          switch_referential if @api_key
        end
      end
      def switch_referential
        Apartment::Database.switch(referential.slug)
      end 

    end
  end
end
