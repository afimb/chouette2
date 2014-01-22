class AddTypeAndOptionsToImport < ActiveRecord::Migration
  def change
    change_table :imports do |t|
      t.string :type, :options
    end
    # Import.update_all :type => "NeptuneImport"
  end
end
