class AddBrandingToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :branding_id, :integer, null: true
  end
end
