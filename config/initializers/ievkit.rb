# Provide authentication credentials
Ievkit.configure do |c|
  c.api_endpoint = Rails.application.secrets.api_endpoint
end
