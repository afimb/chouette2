Apartment.configure do |config|
  # set your options (described below) here
  config.excluded_models = ["Referential", "Organisation", "User", "ImportTask", "Export", "ExportLogMessage","ComplianceCheckTask", "ComplianceCheckResult", "Delayed::Backend::ActiveRecord::Job", "Api::V1::ApiKey", "RuleParameterSet"]        # these models will not be multi-tenanted, but remain in the global (public) namespace

  # Dynamically get database names to migrate
  config.database_names = lambda{ Referential.pluck(:slug) }
end
