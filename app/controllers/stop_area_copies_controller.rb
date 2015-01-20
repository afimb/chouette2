class StopAreaCopiesController < ChouetteController
  defaults :resource_class => StopAreaCopy
  belongs_to :referential do
    belongs_to :stop_area, :parent_class => Chouette::StopArea 
  end
  
  actions :new, :create
  respond_to :html, :only => :new
  
  def new    
    @stop_area_copy = StopAreaCopy.new(:hierarchy => params[:hierarchy], :source => parent)
    new! do
      build_breadcrumb :new
    end
  end

  def create
    @stop_area_copy = StopAreaCopy.new(params[:stop_area_copy])
    @stop_area = parent
    if @stop_area_copy.save
      redirect_to referential_stop_area_path( @referential,@stop_area_copy.copy ), notice: I18n.t("stop_area_copies.new.success")
    else
      flash[:error] = I18n.t("stop_area_copies.errors.copy_aborted") + "<br>" + @stop_area_copy.errors.full_messages.join("<br>")
      render :action => :new
    end
  end

  protected 

end
