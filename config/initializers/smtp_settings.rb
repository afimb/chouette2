ActionMailer::Base.smtp_settings = {
  address: Rails.application.secrets.smtp_host,
  port: Rails.application.secrets.smtp_port,
  domain: Rails.application.secrets.smtp_domain,
  user_name: Rails.application.secrets.smtp_user_name,
  password: Rails.application.secrets.smtp_password,
  authentication: Rails.application.secrets.smtp_authentication
}
