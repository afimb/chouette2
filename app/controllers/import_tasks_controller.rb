class ImportTasksController < ChouetteController
  defaults :resource_class => ImportTask
  
  respond_to :html
  belongs_to :referential

  def new
    begin
      new!
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  def create
    #begin
      neptune_import = NeptuneImport.new(params[:import_task])
      neptune_import.save
    # rescue Ievkit::Error => error
    #   logger.error("Iev failure : #{error.message}")
    #   flash[:error] = t('iev.failure')
    #   redirect_to referential_path(@referential)
    # end
  end

  protected

  def build_resource(attributes = {})
    @csv_import ||= CsvImport.new(:referential_id => @referential.id )
    @neptune_import ||= NeptuneImport.new(:referential_id => @referential.id )
    @netex_import ||= NetexImport.new(:referential_id => @referential.id )
    @gtfs_import ||= GtfsImport.new(:referential_id => @referential.id )
  end
  
end
