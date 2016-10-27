# Provide authentication credentials
Ievkitdeprecated.configure do |c|
 c.api_endpoint = Rails.application.secrets.api_endpoint
end
