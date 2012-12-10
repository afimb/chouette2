module ApiKeyHelper

  def get_api_key
    Api::V1::ApiKey.create( referential.organisation, referential)
  end
  def config_formatted_request_with_authorization( format)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( get_api_key.token)
    request.accept = format
  end
  def config_formatted_request_with_dummy_authorization( format)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( "dummy")
    request.accept = format
  end
  def config_formatted_request_without_authorization( format)
    request.env['HTTP_AUTHORIZATION'] = nil
    request.accept = format
  end
  def json_xml_format?
    request.accept == "application/json" || request.accept == "application/xml"
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :api_key, :get_api_key
    end
  end

  module ClassMethods
    def assign_api_key
      before(:each) do
        assign :api_key, api_key
      end
    end
  end

end

RSpec.configure do |config|
  config.include ApiKeyHelper
end

