# -*- coding: utf-8 -*-
# Expects responses like:
#
#     {
#       "result": { "id": 1, "name": "Tobias Fünke" },
#       "errors": []
#     }
#
require 'faraday'

module IevApi
  module Middleware
    class CustomParser < Faraday::Response::Middleware
      def on_complete(env)
        body = env[:body]
        env[:body] = {
          datas: body,
          headers: env[:response_headers],
          links: process_links(env[:response_headers])
        }
      end

      # Finds link relations from 'Link' response header
      def process_links(headers)
        puts headers.inspect
        links = ( headers["Link"] || "" ).split(', ').map do |link|
          href, name = link.match(/<(.*?)>; rel="(\w+)"/).captures
          
          [name.to_sym, href]
        end
        puts links.inspect
        Hash[*links.flatten]
      end
      
    end
  end
end
