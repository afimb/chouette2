class CreateOrganisation < ActiveRecord::Migration
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
  end

  def down
    drop_table :organisations
  end
end
