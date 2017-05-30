class CreateCodespaces < ActiveRecord::Migration
  def change
    create_table :codespaces do |t|
      t.string :xmlns, null: false
      t.string :xmlnsurl, null: false

      t.timestamps
    end
  end
end
