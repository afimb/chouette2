class StopAreaExportsController < ChouetteController
  belongs_to :referential
    
  respond_to :csv, :only => [:index]
  respond_to :xls, :only => [:index] 

  def index
    @column_names = column_names 
    index! do |format|
      format.csv { send_data StopAreaExport.new( {:column_names => column_names, :stop_areas => collection} ).to_csv  }
      format.xls
    end
  end
  
  protected 

  def column_names
    ["id","name","longitude","latitude","area_type","parent_id", "comment","country_code","street_name","mobility_restricted_suitability","stairs_availability","lift_availability","int_user_needs"]
  end
  
  def collection
    @stop_areas ||= Chouette::StopArea.order(:country_code, :name)
  end
  
end
