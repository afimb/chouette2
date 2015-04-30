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
    
  def compliance_check
    @compliance_check ||= compliance_check_service.find( params[:compliance_check_id] )
  end
  
  def compliance_check_validation_report
    @compliance_check_validation_report ||= compliance_check.compliance_check_validation_report
  end
  
  def collection
    @compliance_check_validation_reports ||= compliance_check_validation_report.all(params[:status], params[:severity]) #.paginate(:page => params[:page])
  end
  
  def rule_parameter_set
    @rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = resource.parameter_set }
  end
end
