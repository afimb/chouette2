class AddFileTypeToImport < ActiveRecord::Migration[4.2]
  def change
    change_table :imports do |t|
      t.string :file_type
    end
    #Import.update_all :file_type => "zip"
  end
end
