class DropFileValidation < ActiveRecord::Migration[4.2]
  def change
    if table_exists? :file_validation_log_messages
      execute "drop table file_validation_log_messages"
      # drop_table :file_validation_log_messages
    end

    if table_exists? :file_validations
      execute "drop table file_validations"
      # drop_table :file_validations
    end
    
  end
end
