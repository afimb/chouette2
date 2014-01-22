class AddOrganisationIdToFileValidation < ActiveRecord::Migration
  def change
    change_table :file_validations do |f|
      f.belongs_to :organisation
    end
    
    #FileValidation.reset_column_information
    #organisation = Organisation.find_or_create_by_name!("Chouette")
    #FileValidation.update_all :organisation_id => organisation.id
    
  end
end
