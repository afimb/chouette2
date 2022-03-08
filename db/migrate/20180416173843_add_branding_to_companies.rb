class AddBrandingToCompanies < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :branding_id, :integer, null: true
  end
end
