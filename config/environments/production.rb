ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  #
  # replace this with your production tracker code
  GA.tracker = "UA-AAAAAAAA"

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

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
  config.geoportail_api_key = "aaaaaaaaaaaaaa"

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'my-domain-name.com' }

  # Configure the e-mail address which will be shown in Devise::Maile
  config.mailer_sender = "chouette-production@my-domain-name.com"

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
   ActionMailer::Base.smtp_settings = {
    :address        => "smtp.samle.com",
    :domain         => "sample.com"
  }
  #end

  # file to data for demo
  config.demo_data = "/path/to/demo.zip"

  # link to validation specification pages
  config.validation_spec = "http://www.chouette.mobi/neptune-validation/v20/"

  # paths for external resources
  config.to_prepare do
    Devise::Mailer.layout "mailer"
    Chouette::Command.command = "tmp/chouette-command/chouette"
    ImportTask.root = "/var/lib/chouette/imports"
    Export.root = "/var/lib/chouette/exports"
  end

end
