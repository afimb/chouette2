# ENV["CHOUETTE_RUN_MIGRATIONS"] = "true"
ChouetteIhm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

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

  ActionMailer::Base.smtp_settings = {
    :address        => "mail.dryade.priv",
    :domain         => "dryade.priv"
  }

  config.to_prepare do
    Devise::Mailer.layout "mailer"
    ApplicationMap.ign_api_key = "41k8m3tx1515p9by2mrvncva"
    chouette_command_script = "tmp/chouette-command/chouette"
    if File.exists? chouette_command_script
      Chouette::Command.command = "tmp/chouette-command/chouette"
    else
      Chouette::Command.command = "true"
    end
  end
  
end
