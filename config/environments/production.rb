ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'
  
  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  
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

  # replace this with your production tracker code
  # replace this with your production tracker code
  if ENV['CHOUETTE_GOOGLE_ANALYTICS'].nil?
     GA.tracker = "UA-AAAAAAAA"
  else
     GA.tracker = ENV['CHOUETTE_GOOGLE_ANALYTICS']
  end  

  # api key to geoportail IGN (production key link to application url root referer)
  if !ENV['CHOUETTE_GEOPORTAIL_KEY'].nil?
     config.geoportail_api_key = ENV['CHOUETTE_GEOPORTAIL_KEY']
  end  

  # Specific theme for each company
  # AFIMB
  config.company_name = "afimb"  
  config.company_theme = "#61970b" # AFIMB color
  config.company_contact = "http://www.chouette.mobi/contact-support/"
  config.accept_user_creation = true  

  # CITYWAY
  # config.company_name = "cityway"
  # config.company_theme = "#32adb0"
  # config.company_contact = "http://www.cityway.fr/contact/?rub_code=14"
  # config.accept_user_creation = false  

  # file to data for demo
  config.demo_data = ENV['CHOUETTE_DEMO_DATA'].nil? ? "/path/to/demo.zip" : ENV['CHOUETTE_DEMO_DATA']

  # link to validation specification pages
  config.validation_spec = "http://www.chouette.mobi/neptune-validation/v20/"

  # paths for external resources
  config.to_prepare do
    Devise::Mailer.layout "mailer"
    Chouette::Command.command = ENV['CHOUETTE_GUI_COMMAND'].nil? ? "/usr/local/opt/chouette-command/chouette-cmd_2.5.1/chouette" : ENV['CHOUETTE_GUI_COMMAND']
    ImportTask.root = "/var/lib/chouette/imports"
    Export.root = "/var/lib/chouette/exports"
  end

  config.i18n.available_locales = [:fr, :en]

end
