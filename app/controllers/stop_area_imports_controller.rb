class StopAreaImportsController < ChouetteController
  belongs_to :referential
  
  actions :new, :create
  respond_to :html, :only => :new
  
  def new    
    @stop_area_import = StopAreaImport.new
    new!
  end

  def create
    @stop_area_import = StopAreaImport.new(params[:stop_area_import])
    if @stop_area_import.save
      redirect_to referential_stop_areas_path( @referential ), notice: I18n.t("stop_area_imports.new.success")
    else
      flash[:error] = I18n.t("stop_area_imports.errors.import_aborted") + "<br>" + @stop_area_import.errors.full_messages.join("<br>")
      render :new 
    end
  end

  protected 

end
