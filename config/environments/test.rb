Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.eager_load = false

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_assets  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
  config.active_support.test_order = :sorted # or `:random` if you prefer

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Specific theme for each company
  # AFIMB
  config.company_name = "afimb"
  config.company_theme = "#61970b" # AFIMB color
  config.company_contact = "http://www.chouette.mobi/club-utilisateurs/contact-support/"
  config.accept_user_creation = true

  # CITYWAY
  # config.company_name = "cityway"
  # config.company_theme = "#32adb0"
  # config.company_contact = "http://www.cityway.fr/contact/?rub_code=14"
  # config.accept_user_creation = false

  # file to data for demo
  config.demo_data = "tmp/demo.zip"

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Configure the e-mail address which will be shown in Devise::Maile
  config.mailer_sender = "appli@chouette.mobi"

  config.action_mailer.delivery_method = :sendmail
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  config.i18n.available_locales = [:fr, :en]
end
