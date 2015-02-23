require 'iev_api/configuration'

module IevApi
  extend Configuration

  class IevError < StandardError; end

  def self.client(options={})
    IevApi::Client.new(options)
  end

   # Delegate to Instapaper::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  def self.respond_to?(method, include_private = false)
    client.respond_to?(method, include_private) || super(method, include_private)
  end
end

require 'iev_api/client'
