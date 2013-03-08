ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

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

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  #config.log_level = :info

  # Use a different logger for distributed setups
	require 'syslog_logger'
  config.logger = SyslogLogger.new("rails/chouette2").tap do |logger|
	  # logger.level = Logger::INFO
	end

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  #config.action_controller.asset_host = "chouette2/assets"
  #config.assets.prefix = "/chouette2/assets"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # NOTICE : With Rails 3.2, Delayed::JRubyWorker blocks the application without threaded mode
  config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'chouette.dryade.net/chouette2' }

  ActionMailer::Base.delivery_method = :sendmail
  
  config.to_prepare do
    Devise::Mailer.layout "mailer"
    Chouette::Command.command = "/usr/local/opt/chouette-command/chouette-gui-2.0.3/chouette"
    Import.root = "/var/lib/chouette/imports"
    Export.root = "/var/lib/chouette/exports"
    FileValidation.root = "/var/lib/chouette/validations"
  end

end
