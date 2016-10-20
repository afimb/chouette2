require 'faraday'
require 'ievkitdeprecated/error'

module Ievkitdeprecated
  # Faraday response middleware
  module Response

    # This class raises an Ievkitdeprecated-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Ievkitdeprecated::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
