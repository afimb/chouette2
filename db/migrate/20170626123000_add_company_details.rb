class AddCompanyDetails < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :organisation_type, :string
    add_column :companies, :legal_name, :string
    add_column :companies, :public_email, :string
    add_column :companies, :public_url, :string
    add_column :companies, :public_phone, :string
  end
end
