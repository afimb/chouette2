class ExportTasksController < ChouetteController
  defaults :resource_class => ExportTask
  
  respond_to :html, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]
  belongs_to :referential

  def new
    @available_exports = available_exports
    begin
      new!
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  def create
    begin            
      create! do |success, failure|
        success.html { redirect_to referential_exports_path(@referential) }
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def references
    references_type = params[:filter].pluralize
    references = @referential.send(references_type).where("name ilike ?", "%#{params[:q]}%").select("id, name")
    puts references.inspect
    respond_to do |format|
      format.json do
        render :json => references.collect { |child| { :id => child.id, :name => child.name } }
      end
    end
  end

  protected

  def available_exports
    @available_exports ||= [
      NeptuneExport.new(:referential_id => @referential.id ),
      NetexExport.new(:referential_id => @referential.id ),
      GtfsExport.new(:referential_id => @referential.id ),
      HubExport.new(:referential_id => @referential.id ),
      KmlExport.new(:referential_id => @referential.id )
    ]
  end

  def build_resource
    export_task_parameters = params[:export_task]
    
    if export_task_parameters.present?
      case export_task_parameters[:data_format]
      when "neptune"
        @export_task = NeptuneExport.new(export_task_parameters)
      when "netex"
        @export_task = NetexExport.new(export_task_parameters)
      when "gtfs"
        @export_task = GtfsExport.new(export_task_parameters)
      when "hub"
        @export_task = HubExport.new(export_task_parameters)
      when "kml"
        @export_task = KmlExport.new(export_task_parameters)
      else
        @export_task = nil
      end
    else
      @export_task = nil
    end
  end
  
end
