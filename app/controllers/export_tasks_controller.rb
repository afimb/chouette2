class ExportTasksController < ChouetteController
  defaults :resource_class => ExportTask
  
  respond_to :html, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]
  belongs_to :referential

  def new
    @available_exports = available_exports
    begin
      new!
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end
  
  def create
    @available_exports = available_exports
    begin            
      create! do |success, failure|
        success.html { redirect_to referential_exports_path(@referential) }
      end
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  def references
    references_type = params[:filter].pluralize
    references = @referential.send(references_type).where("name ilike ?", "%#{params[:q]}%").select("id, name")
    respond_to do |format|
      format.json do
        render :json => references.collect { |child| { :id => child.id, :name => child.name } }
      end
    end
  end

  protected

  def available_exports
    export_task_parameters = params[:export_task]
    if export_task_parameters.present?
      @available_exports = [
        export_task_parameters[:data_format] == "neptune" ? build_resource : NeptuneExport.new(:referential_id => @referential.id ),
        export_task_parameters[:data_format] == "netex" ? build_resource : NetexExport.new(:referential_id => @referential.id ),
        export_task_parameters[:data_format] == "gtfs" ? build_resource : GtfsExport.new(:referential_id => @referential.id ),
        export_task_parameters[:data_format] == "hub" ? build_resource : HubExport.new(:referential_id => @referential.id ),
        export_task_parameters[:data_format] == "kml" ? build_resource : KmlExport.new(:referential_id => @referential.id )
      ]
    else
      @available_exports = [
        NeptuneExport.new(:referential_id => @referential.id ),
        NetexExport.new(:referential_id => @referential.id ),
        GtfsExport.new(:referential_id => @referential.id ),
        HubExport.new(:referential_id => @referential.id ),
        KmlExport.new(:referential_id => @referential.id )
      ]
    end
  end

  def build_resource    
    @export_task ||= if params[:export_task].present?
                       export_task_parameters = params[:export_task]
                       export_task_parameters[:reference_ids] = export_task_parameters[:reference_ids].to_s.split(',').map(&:to_i)
                       case export_task_parameters[:data_format]
                       when "neptune"
                         NeptuneExport.new(export_task_parameters)
                       when "netex"
                         NetexExport.new(export_task_parameters)
                       when "gtfs"
                         GtfsExport.new(export_task_parameters)
                       when "hub"
                         HubExport.new(export_task_parameters)
                       when "kml"
                         KmlExport.new(export_task_parameters)
                       end
                     else
                       NeptuneExport.new
                     end
  end
  
end
