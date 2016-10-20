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
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.exception.default')
      redirect_to referential_path(@referential)
    end
  end

  def create
    @available_imports = available_imports
    begin
      create! do |success, failure|
        success.html { redirect_to referential_imports_path(@referential) }
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.exception.default')
      redirect_to referential_path(@referential)
    end
  end

  protected

  def available_imports
    import_task_parameters = params[:import_task]

    if import_task_parameters.present?
      @available_imports = [
        import_task_parameters[:data_format] == "neptune" ? build_resource : NeptuneImport.new(:referential_id => @referential.id ),
        import_task_parameters[:data_format] == "netex" ? build_resource : NetexImport.new(:referential_id => @referential.id ),
        import_task_parameters[:data_format] == "gtfs" ? build_resource : GtfsImport.new(:referential_id => @referential.id ),
        import_task_parameters[:data_format] == "regtopp" ? build_resource : RegtoppImport.new(:referential_id => @referential.id ),
        import_task_parameters[:data_format] == "netexprofile" ? build_resource : NetexprofileImport.new(:referential_id => @referential.id )
      ]
    else
      @available_imports = [
        NeptuneImport.new(:referential_id => @referential.id ),
        NetexImport.new(:referential_id => @referential.id ),
        GtfsImport.new(:referential_id => @referential.id ),
        RegtoppImport.new(:referential_id => @referential.id ),
        NetexprofileImport.new(:referential_id => @referential.id )
      ]
    end
  end

  def build_resource
    @import_task ||= if params[:import_task].present?
                       import_task_parameters = params[:import_task]
                       case import_task_parameters[:data_format]
                       when "neptune"
                         NeptuneImport.new(import_task_parameters)
                       when "netex"
                         @import_task = NetexImport.new(import_task_parameters)
                       when "netexprofile"
                         @import_task = NetexprofileImport.new(import_task_parameters)
                       when "gtfs"
                         @import_task = GtfsImport.new(import_task_parameters)
                       when "regtopp"
                         @import_task = RegtoppImport.new(import_task_parameters)
                       end
                     else
                       @import_task = NeptuneImport.new
                     end
  end

end
