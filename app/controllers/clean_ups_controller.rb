class CleanUpsController < ChouetteController
  respond_to :html, :only => [:create]

  belongs_to :referential 

  def create
    clean_up = CleanUp.new( params[:clean_up])
    if clean_up.invalid?
      flash[:alert] = clean_up.errors.full_messages.join("<br/>")
    else
      begin
        result = clean_up.clean
        flash[:notice] = result.notice.join("<br/>")
      rescue
        flash[:alert] = t('clean_ups.failure') + $!
      end
    end
    redirect_to referential_path(@referential)

  end
  
end
