# ENV["CHOUETTE_RUN_MIGRATIONS"] = "true"
ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.active_record.mass_assignment_sanitizer = :strict

  # uncomment to show chouette error view in development
  #config.consider_all_requests_local = false

  config.active_record.auto_explain_threshold_in_seconds = (RUBY_PLATFORM == "java" ? nil : 0.5)

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # replace this with your production tracker code
  GA.tracker = "UA-AAAAAAAA"

  # api key to geoportail IGN (production key link to application url root referer)
  config.geoportail_api_key = "aaaaaaaaaaaaaa" 

  # Specific for each company
  config.company_name = "afimb"
  config.company_theme = "#61970b"
  config.company_contact = "http://www.chouette.mobi/contact-support/"
  
  # file to data for demo
  config.demo_data = "tmp/demo.zip"

  # link to validation specification pages
  config.validation_spec = "http://www.chouette.mobi/neptune-validation/v20/"

  # Configure the e-mail address which will be shown in Devise::Maile
  config.mailer_sender = "appli@chouette.mobi"

  ActionMailer::Base.smtp_settings = {
    :address        => "smtp.samle.com",
    :domain         => "sample.com"
  }

  # api key to geoportail IGN (development key 3 month validity)
  # config.geoportail_api_key = "f1t6wihbh98njlbaf5cuzxy4"

  config.to_prepare do
    Devise::Mailer.layout "mailer"
    #ApplicationMap.ign_api_key = "i2aqyge3x3iovnuhz7z06flp"
    chouette_command_script = "/home/zbouziane/Projects/dryade/chouette2_dev/tmp/chouette-command/chouette"
    if File.exists? chouette_command_script
      Chouette::Command.command = "/home/zbouziane/Projects/dryade/chouette2_dev/tmp/chouette-command/chouette"
    else
      Chouette::Command.command = "true"
    end
  end

  Nominatim.configure do |config|
    config.email = 'zbouziane@gmail.com'
    config.endpoint = 'http://open.mapquestapi.com/nominatim/v1'
  end
  
end
