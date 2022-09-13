Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.eager_load = true

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Must add sub uri for controllers.
  # config.action_controller.relative_url_root = "/chouette2"

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.public_file_server.enabled = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Must add sub uri for assets. Same as config.action_controller.relative_url_root
  # config.assets.prefix = "/chouette2"

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :warn
  config.action_view.logger = nil

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  #if ENV['OS'] == 'Windows_NT'
  #  # args = log_path,number of files,file sizes
  #  config.logger = Logger.new("C:/chouette/logs/chouette2.log", 5, 10.megabytes)
  # config.logger = ActiveSupport::TaggedLogging.new(
  #   Syslog::Logger.new("rails/chouette2").tap{ |syslog| syslog.level = Logger::INFO }
  # )
  config.logger = Logger.new(STDOUT)

  # Google analytics tracker
  GA.tracker = Rails.application.secrets.google_analytics_tracker

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

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


  config.action_mailer.default_url_options = { host: Rails.application.secrets.domain_name }

  config.action_mailer.delivery_method = Rails.application.secrets.smtp_delivery_method.to_sym

  # Configure the e-mail address which will be shown in Devise::Maile
  config.mailer_sender = Rails.application.secrets.mailer_sender

  # Specific theme for each company
  # AFIMB
  #config.company_name = "afimb"
  #config.company_theme = "#61970b" # AFIMB color
  #config.company_contact = "http://www.chouette.mobi/club-utilisateurs/contact-support/"
  #config.accept_user_creation = true

  # CITYWAY
  # config.company_name = "cityway"
  # config.company_theme = "#32adb0"
  # config.company_contact = "http://www.cityway.fr/contact/?rub_code=14"
  # config.accept_user_creation = false

  # Rutebanken
   config.company_name = "Entur"
   config.company_theme = "#5AC39A" # Entur color
   config.company_contact = "http://www.entur.org/kontakt/"
   config.accept_user_creation = false

  # file to data for demo
  # config.demo_data = "/path/to/demo.zip"

  # paths for external resources
  config.to_prepare do
    Devise::Mailer.layout 'mailer'
  end

  config.i18n.available_locales = [:fr, :en, :nb]
end
