class CreateChouetteFacilityFeature < ActiveRecord::Migration
  def up
    create_table :facilities_features, :id => false, :force => true do |t|
      t.integer  "facility_id", :limit => 8
      t.integer  "choice_code"
    end
  end

  def down
    drop_table :facilities_features 
  end
end
