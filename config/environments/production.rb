ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  #
  # # replace this with your production tracker code
  GA.tracker = "UA-xxxxxx-x"

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  # Uncomment to add suburi for your application
  #config.action_controller.relative_url_root = "/chouette2"

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
  #if ENV['OS'] == 'Windows_NT'
  #  # args = log_path,number of files,file sizes
  #  config.logger = Logger.new("C:/chouette/logs/chouette2.log", 5, 10.megabytes)
  #else
    require 'syslog_logger'
    config.logger = SyslogLogger.new("rails/chouette2").tap do |logger|
      # logger.level = Logger::INFO
    end
  #end


  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  #config.action_controller.asset_host = "chouette2/assets"
  #config.assets.prefix = "/chouette2/assets"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  #
  # api key to geoportail IGN (production key link to public site url referer)
  #config.geoportail_api_key = "bt4z711qv8uw4zmk2bxl4d5l"

  # Enable threaded mode
  # NOTICE : With Rails 3.2, Delayed::JRubyWorker blocks the application without threaded mode
  config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'hostname.com' }



  #  mailer configuration :
  #  by default : set to smtp on windows platforms and sendmail on unix one
  #               may be changed as convenience
  #if ENV['OS'] == 'Windows_NT'
  #  ## using SMTP (maybe useful for Windows or VM platforms):
  #   ActionMailer::Base.delivery_method = :smtp
  #   ActionMailer::Base.smtp_settings = {
  #     :address => "smtp.sample.com",
  #    #:port => 25,
  #     :domain => "sample.com",
  #     #:authentication => :login,
  #     :user_name => "username",
  #     #:password => "password",
  #     #:enable_starttls_auto => true,
  #     #openssl_verify_mode => # set one in 'none' 'peer' 'client_once' 'fail_if_no_peer_cert'
  #   }
  #else
    ActionMailer::Base.smtp_settings = {
      :address              => "smtp.sample.com",
      :port                 => 25,
      :domain               => "sample.com",
      :user_name            => "username",
      :password             => "password",
      :authentication       => "plain"
    }
  #end

  # file to data for demo
  config.demo_data = "/var/lib/chouette/demo.zip"

  # paths for external resources
  #if ENV['OS'] == 'Windows_NT'
  #  config.to_prepare do
  #    Devise::Mailer.layout "mailer"
  #    Chouette::Command.command = "C:/chouette/chouette-cmd_2.2.0/chouette.bat"
  #    ImportTask.root = "C:/chouette/chouette/imports"
  #    Export.root = "C:/chouette/chouette/exports"
  #  end
  #else
    config.to_prepare do
      Devise::Mailer.layout "mailer"
      Chouette::Command.command = "/usr/local/opt/chouette-command/chouette-cmd_2.2.0/chouette"
      ImportTask.root = "/var/lib/chouette/imports"
      Export.root = "/var/lib/chouette/exports"
    end
  #end

end
