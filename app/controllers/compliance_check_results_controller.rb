class ComplianceCheckResultsController < ChouetteController

  defaults :resource_class => ComplianceCheckResult
  
  respond_to :json
  respond_to :js, :only => :index
  
  def index
    #puts "params = #{params.inspect}"
    index! do |format|
      format.html { render :layout => false }
    end
  end

  protected

  def compliance_check_service
    ComplianceCheckService.new(@referential)
  end
    
  def compliance_check_task
    @compliance_check_task ||= compliance_check_service.find( params[:compliance_check_task_id] )
  end
  
  def compliance_check_result
    @compliance_check_result ||= compliance_check_task.compliance_check_result
  end
  
  def collection
    @compliance_check_results ||= compliance_check_result.all(params[:status], params[:severity]) #.paginate(:page => params[:page])
  end
  
  def rule_parameter_set
    @rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = resource.parameter_set }
  end
end
