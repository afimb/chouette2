# coding: utf-8
class ImportTasksController < ChouetteController
  defaults :resource_class => ImportTask
  
  respond_to :html, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]
  belongs_to :referential

  def new
    @available_imports = available_imports
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
        success.html { redirect_to referential_imports_path(@referential) }
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  protected

  def available_imports
    @available_imports ||= [
      NeptuneImport.new(:referential_id => @referential.id ),
      NetexImport.new(:referential_id => @referential.id ),
      GtfsImport.new(:referential_id => @referential.id )
    ]
  end
  
  def build_resource
    import_task_parameters = params[:import_task]
    
    if import_task_parameters.present?
      case import_task_parameters[:data_format]
      when "neptune"
        @import_task = NeptuneImport.new(import_task_parameters)
      when "netex"
        @import_task = NetexImport.new(import_task_parameters)
      when "gtfs"
        @import_task = GtfsImport.new(import_task_parameters)
      else
        @import_task = nil
      end
    else
      @import_task = nil
    end
  end
  
end
