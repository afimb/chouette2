require 'faraday'

module IevApi
  module Middleware
    class RaiseResponseError < Faraday::Response::Middleware

      def on_complete(env)
        raise IevError.new('No results found.') if env[:body].nil?
      end

    end
  end
end
