require 'faraday'

module IevApi
  module Middleware
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 403
          raise IevError.new('SSL should be enabled - use AirbrakeAPI.secure = true in configuration')
        when 404
          raise IevError.new('No resource found')
        end
      end

    end
  end
end
