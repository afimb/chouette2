module Ievkitdeprecated

  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable

    attr_accessor :access_token, :auto_paginate, :client_id,
                  :client_secret, :default_media_type, :connection_options,
                  :middleware, :netrc, :netrc_file,
                  :per_page, :proxy, :user_agent
    attr_writer :password, :web_endpoint, :api_endpoint, :login

    class << self

      # List of configurable keys for {Octokit::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :auto_paginate,
          :client_id,
          :client_secret,
          :connection_options,
          :default_media_type,
          :login,
          :middleware,
          :netrc,
          :netrc_file,
          :per_page,
          :password,
          :proxy,
          :user_agent,
          :web_endpoint
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Ievkitdeprecated::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Ievkitdeprecated::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    # Base URL for generated web URLs
    #
    # @return [String] Default: https://github.com/
    def web_endpoint
      File.join(@web_endpoint, "")
    end

    def login
      @login ||= begin
        user.login if token_authenticated?
      end
    end

    def netrc?
      !!@netrc
    end

    private

    def options
      Hash[Ievkitdeprecated::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def fetch_client_id_and_secret(overrides = {})
      opts = options.merge(overrides)
      opts.values_at :client_id, :client_secret
    end
  end
end
