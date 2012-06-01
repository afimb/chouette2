Apartment.configure do |config|
  # set your options (described below) here
  config.excluded_models = ["Referential", "User", "Import", "ImportLogMessage", "Delayed::Backend::ActiveRecord::Job"]        # these models will not be multi-tenanted, but remain in the global (public) namespace

  # Dynamically get database names to migrate
  config.database_names = lambda{ Referential.select(:slug).map(&:slug) }
end
