Apartment.configure do |config|
  # set your options (described below) here
  config.excluded_models = ["Referential"]        # these models will not be multi-tenanted, but remain in the global (public) namespace
end