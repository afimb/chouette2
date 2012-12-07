module Api
  module V1
    class ChouetteController < ActionController::Base
      respond_to :json, :xml
      layout false
      before_filter :authenticate

      def referential
        @referential ||= @api_key.referential
      end
private
      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @api_key = ApiKey.new(token)
          switch_referential if @api_key.exists?
        end
      end
      def switch_referential
        Apartment::Database.switch(referential.slug)
      end 

    end
  end
end
