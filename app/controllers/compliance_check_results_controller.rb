class ComplianceCheckResultsController < ChouetteController
  
  respond_to :json
  respond_to :js, :only => :index
  #respond_to :csv, :only => :index
  belongs_to :compliance_check_task

  def index
    index! do |format|
      format.html { render :layout => false }
      #format.csv { send_file collection[0].compliance_check_task.file, :type => "text/html; charset=utf-8" }
    end
  end
  
  def collection
    wheres = [:status, :severity].map{|key| params.has_key?(key) ? {key => params[key]} : {} }\
      .inject({}){|hash, injected| hash.merge!(injected)}
    @compliance_check_results ||= end_of_association_chain.where(wheres).order(:rule_code)
  end
  
  def rule_parameter_set
    @rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = resource.parameter_set }
  end
  
end
