class ResizeColumns < ActiveRecord::Migration[4.2]
  def change
    change_column "referentials", "organisation_id", "integer", {:limit => 8}
    change_column "imports", "referential_id", "integer", {:limit => 8}
    change_column "import_log_messages", "import_id", "integer", {:limit => 8}
    change_column "exports", "referential_id", "integer", {:limit => 8}
    change_column "export_log_messages", "export_id", "integer", {:limit => 8}
    change_column "file_validations", "organisation_id", "integer", {:limit => 8}
    change_column "file_validation_log_messages", "file_validation_id", "integer", {:limit => 8}
  end
end
