class ValidationResultsController < ChouetteController

  defaults :resource_class => ValidationReport
  
  respond_to :json
  respond_to :js, :only => :index

  def index
    index! do |format|
      format.html { render :layout => false }
    end
  end

  protected

  def validation_service
    ValidationService.new(@referential)
  end
    
  def validation
    @validation ||= validation_service.find( params[:validation_id] )
  end
  
  def validation_report
    @validation_report ||= validation.report
  end
  
  def collection
    @validation_results ||= validation_report.all(params[:status], params[:severity]) #.paginate(:page => params[:page])
  end
  
  def rule_parameter_set
    @rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = resource.parameter_set }
  end
end
