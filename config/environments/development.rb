Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  #config.active_record.auto_explain_threshold_in_seconds = (RUBY_PLATFORM == "java" ? nil : 0.5)

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
  config.action_mailer.delivery_method = :sendmail 
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  # replace this with your production tracker code
  GA.tracker = "UA-AAAAAAAA"

  # api key to geoportail IGN (production key link to application url root referer)
  #config.geoportail_api_key = "aaaaaaaaaaaaaa"

  # Iev server url
  config.iev_url="localhost:8080/mobi.chouette.api"
  
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
  config.demo_data = "tmp/demo.zip"
  
  # link to validation specification pages
  config.validation_spec = "http://www.chouette.mobi/neptune-validation/v20/"

  # Configure the e-mail address which will be shown in Devise::Mailer
  config.mailer_sender = "appli@chouette.mobi"

  config.action_mailer.delivery_method = :sendmail 
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
  
  # api key to geoportail IGN (development key 3 month validity)
  # config.geoportail_api_key = "f1t6wihbh98njlbaf5cuzxy4"
  
  config.to_prepare do
    Devise::Mailer.layout "mailer"
    #ApplicationMap.ign_api_key = "i2aqyge3x3iovnuhz7z06flp"
    chouette_command_script = "tmp/chouette-command/chouette"
    if File.exists? chouette_command_script
      Chouette::Command.command = "tmp/chouette-command/chouette"
    else
      Chouette::Command.command = "true"
    end
  end
  
  config.i18n.available_locales = [:fr, :en]
end
