class CleanUpsController < ChouetteController
  respond_to :html, :only => [:create]

  belongs_to :referential 

  def create
    begin
      clean_up = CleanUp.new( params[:clean_up])
      clean_up.clean
      #flash[:notice] = "Message 1<br />"
      #flash[:notice] << "Message 2"
      notice = t('clean_ups.success_tm', :tm_count => clean_up.time_table_count.to_s)
      if (clean_up.vehicle_journey_count > 0) 
        notice += t('clean_ups.success_vj', :vj_count => clean_up.vehicle_journey_count.to_s)
      end   
      flash[:notice] = notice
    rescue
      flash[:alert] = t('clean_ups.failure')
    end
    redirect_to referential_path(@referential)

  end
  
end
