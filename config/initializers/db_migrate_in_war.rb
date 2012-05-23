Rails.configuration.after_initialize do
  Rails.logger.info "Migrating database"
  ActiveRecord::Migrator.migrate("db/migrate/", nil)

  Apartment.database_names.each do |db|
    Rails.logger.info "Migrating #{db} schema"
    Apartment::Migrator.migrate db
  end
end if ENV["CHOUETTE_RUN_MIGRATIONS"] == "true"

