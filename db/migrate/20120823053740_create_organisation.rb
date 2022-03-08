class CreateOrganisation < ActiveRecord::Migration[4.2]
  def up
    create_table :organisations do |t|
      t.string :name
      t.timestamps
    end
    change_table :referentials do |n|
      n.belongs_to :organisation
    end
    change_table :users do |u|
      u.belongs_to :organisation
    end

    # Referential.reset_column_information
    # User.reset_column_information

    # organisation = Organisation.first_or_create(:name => "Chouette")
    # Referential.update_all :organisation_id => organisation.id
    # User.update_all :organisation_id => organisation.id
  end

  def down
    drop_table :organisations
  end
end
