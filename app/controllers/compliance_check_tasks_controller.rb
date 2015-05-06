class ComplianceCheckTasksController < ChouetteController
  defaults :resource_class => ComplianceCheckTask

  respond_to :html, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]
  
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
    begin            
      create! do |success, failure|
        success.html { redirect_to referential_compliance_checks_path(@referential) }
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

  def build_resource
    @compliance_check_task ||= ComplianceCheckTask.new( params[:compliance_check_task] || {} )
  end


end
