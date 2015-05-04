require 'sawyer'
require 'ievkit/arguments'
require 'ievkit/configurable'
require 'ievkit/client/jobs'

module Ievkit

  # Client for the Iev API  
  class Client
   
    include Ievkit::Configurable
    include Ievkit::Authentication
    include Ievkit::Client::Jobs

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Ievkit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Ievkit.instance_variable_get(:"@#{key}"))
      end
    end

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    # Text representation of the client, masking tokens and passwords
    #
    # @return [String]
    def inspect
      inspected = super

      # mask password
      inspected = inspected.gsub! @password, "*******" if @password
      # Only show last 4 of token, secret
      if @access_token
        inspected = inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}"
      end
      if @client_secret
        inspected = inspected.gsub! @client_secret, "#{'*'*36}#{@client_secret[36..-1]}"
      end

      inspected
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {})
      request :post, url, options
    end
    
    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def multipart_post(url, options = {})
      multipart_request :post, url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {})
      request :put, url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {})
      request :patch, url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {})
      request :delete, url, options
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def head(url, options = {})
      request :head, url, parse_query_and_convenience_headers(options)
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in {#auto_paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @param block [Block] Block to perform the data concatination of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    # @return [Sawyer::Resource]
    def paginate(url, options = {}, &block)
      opts = parse_query_and_convenience_headers(options.dup)
      if @auto_paginate || @per_page
        opts[:query][:per_page] ||=  @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, opts)

      if @auto_paginate
        while @last_response.rels[:next] && rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get
          if block_given?
            yield(data, @last_response)
          else
            data.concat(@last_response.data) if @last_response.data.is_a?(Array)
          end
        end

      end

      data
    end

    # Hypermedia agent for the Iev API
    #
    # @return [Sawyer::Agent]
    def multipart_agent      
      @multipart_agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options.merge({ :serializer => Ievkit::Serializer.multipart}) ) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:content_type] = "multipart/form-data"
        http.headers[:user_agent] = user_agent
        
        # Activate if authentication is needed
        #
        # if basic_authenticated?
        #   http.basic_auth(@login, @password)
        # elsif token_authenticated?
        #   http.authorization 'token', @access_token
        # elsif application_authenticated?
        #   http.params = http.params.merge application_authentication
        # end
      end
    end
    
    # Hypermedia agent for the Iev API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:content_type] = "application/json"
        http.headers[:user_agent] = user_agent
        
        # Activate if authentication is needed
        #
        # if basic_authenticated?
        #   http.basic_auth(@login, @password)
        # elsif token_authenticated?
        #   http.authorization 'token', @access_token
        # elsif application_authenticated?
        #   http.params = http.params.merge application_authentication
        # end
      end
    end

    # Fetch the root resource for the API
    #
    # @return [Sawyer::Resource]
    def root
      get "/"
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response if defined? @last_response
    end

    # Duplicate client using client_id and client_secret as
    # Basic Authentication credentials.
    # @example
    #   Ievkit.client_id = "foo"
    #   Ievkit.client_secret = "bar"
    #
    #   # GET https://api.github.com/?client_id=foo&client_secret=bar
    #   Ievkit.get "/"
    #
    #   Ievkit.client.as_app do |client|
    #     # GET https://foo:bar@api.github.com/
    #     client.get "/"
    #   end
    def as_app(key = client_id, secret = client_secret, &block)
      if key.to_s.empty? || secret.to_s.empty?
        raise ApplicationCredentialsRequired, "client_id and client_secret required"
      end
      app_client = self.dup
      app_client.client_id = app_client.client_secret = nil
      app_client.login    = key
      app_client.password = secret

      yield app_client if block_given?
    end

    # Set username for authentication
    #
    # @param value [String] GitHub username
    def login=(value)
      reset_agent
      @login = value
    end

    # Set password for authentication
    #
    # @param value [String] GitHub password
    def password=(value)
      reset_agent
      @password = value
    end

    # Set OAuth access token for authentication
    #
    # @param value [String] 40 character GitHub OAuth access token
    def access_token=(value)
      reset_agent
      @access_token = value
    end

    # Set OAuth app client_id
    #
    # @param value [String] 20 character GitHub OAuth app client_id
    def client_id=(value)
      reset_agent
      @client_id = value
    end

    # Set OAuth app client_secret
    #
    # @param value [String] 40 character GitHub OAuth app client_secret
    def client_secret=(value)
      reset_agent
      @client_secret = value
    end

    # Wrapper around Kernel#warn to print warnings unless
    # IEVKIT_SILENT is set to true.
    #
    # @return [nil]
    def ievkit_warn(*message)
      unless ENV['IEVKIT_SILENT']
        warn message
      end
    end

    private

    def reset_agent
      @agent = nil
    end

    def multipart_request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end
      
      @last_response = response = multipart_agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response.data
    end
    
    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end
      
      @last_response = response = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response.data
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Ievkit::NotFound
      false
    end


    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Hal.new
      }
      conn_opts = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)
      opts[:serializer] = Ievkit::Serializer.any_json

      opts
    end

    def parse_query_and_convenience_headers(options)
      headers = options.fetch(:headers, {})
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end
  end
end
