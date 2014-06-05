ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  #
  # replace this with your production tracker code
  if ENV['CHOUETTE_GOOGLE_ANALYTICS'].nil?
     GA.tracker = "UA-AAAAAAAA"
  else
     GA.tracker = ENV['CHOUETTE_GOOGLE_ANALYTICS']
  end  

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = false

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Use a different logger for distributed setups
  #if ENV['OS'] == 'Windows_NT'
  #  # args = log_path,number of files,file sizes
  #  config.logger = Logger.new("C:/chouette/logs/chouette2.log", 5, 10.megabytes)
  #else
  require 'syslog_logger'
  config.logger = SyslogLogger.new("rails/chouette2").tap do |logger|
    logger.level = Logger::INFO
  end
  #end

  # api key to geoportail IGN (production key link to application url root referer)
  if ENV['CHOUETTE_GEOPORTAIL_KEY'].nil?
     config.geoportail_api_key = "aaaaaaaaaaaaaa"
  else
     config.geoportail_api_key = ENV['CHOUETTE_GEOPORTAIL_KEY']
  end  

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  if ENV['CHOUETTE_BASE_URL'].nil?
     config.action_mailer.default_url_options = { :host => 'my-domain-name.com' }
  else
     config.action_mailer.default_url_options = { :host => ENV['CHOUETTE_BASE_URL'] }
  end  
  

  # Configure the e-mail address which will be shown in Devise::Maile
  if ENV['CHOUETTE_MAIL_SENDER'].nil?
     config.mailer_sender = "chouette-production@my-domain-name.com"
  else
     config.mailer_sender = ENV['CHOUETTE_MAIL_SENDER']
  end  

  #  mailer configuration :
  #  by default : set to smtp on windows platforms and sendmail on unix one
  #               may be changed as convenience
  #if ENV['OS'] == 'Windows_NT'
  #  ## using SMTP (maybe useful for Windows or VM platforms):
  #   ActionMailer::Base.delivery_method = :smtp
  #   ActionMailer::Base.smtp_settings = {
  #     :address => "smtp.sample.com",
  #     :domain => "sample.com",
  #     :user_name => "username",
  #   }
  #else
  mailer = ""
  if ENV['CHOUETTE_MAILER'].nil?
    mailer = "smtp"
  else
    mailer = ENV['CHOUETTE_MAILER']
  end
  if mailer == "smtp"
    if ENV['CHOUETTE_SMTP_USER'].nil?
      ActionMailer::Base.smtp_settings = {
	:address        => ENV['CHOUETTE_SMTP_ADDRESS'].nil? ? "smtp.sample.com" : ENV['CHOUETTE_SMTP_ADDRESS'],
	:port           => ENV['CHOUETTE_SMTP_PORT'].nil? ? 25 : ENV['CHOUETTE_SMTP_PORT'].to_i,
	:domain         => ENV['CHOUETTE_SMTP_DOMAIN'].nil? ? "sample.com" : ENV['CHOUETTE_SMTP_DOMAIN']   }
    else
      ActionMailer::Base.smtp_settings = {
	:address        => ENV['CHOUETTE_SMTP_ADDRESS'],
	:port           => ENV['CHOUETTE_SMTP_PORT'].nil? ? 25 : ENV['CHOUETTE_SMTP_PORT'].to_i,
	:domain         => ENV['CHOUETTE_SMTP_DOMAIN'],
	:user_name      => ENV['CHOUETTE_SMTP_USER'],
	:password       => ENV['CHOUETTE_SMTP_PASSWORD'],
	:authentication => ENV['CHOUETTE_SMTP_AUTH']    }
    end  
  end 
  #end

  # file to data for demo
  config.demo_data = ENV['CHOUETTE_DEMO_DATA'].nil? ? "/path/to/demo.zip" : ENV['CHOUETTE_DEMO_DATA']

  # link to validation specification pages
  config.validation_spec = "http://www.chouette.mobi/neptune-validation/v20/"

  # paths for external resources
  config.to_prepare do
    Devise::Mailer.layout "mailer"
    Chouette::Command.command = ENV['CHOUETTE_GUI_COMMAND'].nil? ? "/usr/local/opt/chouette-command/chouette-cmd_2.4.0/chouette" : ENV['CHOUETTE_GUI_COMMAND']
    ImportTask.root = "/var/lib/chouette/imports"
    Export.root = "/var/lib/chouette/exports"
  end

end
