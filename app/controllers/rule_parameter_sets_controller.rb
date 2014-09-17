class RuleParameterSetsController < ChouetteController
  respond_to :html
  respond_to :js, :only => [ :mode ]

  belongs_to :referential

  def new
    @rule_parameter_set = RuleParameterSet.default( @referential)
    new! do
      add_breadcrumb Referential.human_attribute_name("import_tasks"), referential_import_tasks_path(@referential)
      add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)      
      add_breadcrumb Referential.human_attribute_name("rule_parameter_sets"), referential_rule_parameter_sets_path(@referential)      
    end
  end

  def index
    index! do
      add_breadcrumb Referential.human_attribute_name("import_tasks"), referential_import_tasks_path(@referential)
      add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)      
    end
  end

  def show
    show! do
      add_breadcrumb Referential.human_attribute_name("import_tasks"), referential_import_tasks_path(@referential)
      add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)      
      add_breadcrumb Referential.human_attribute_name("rule_parameter_sets"), referential_rule_parameter_sets_path(@referential)      
    end
  end

  def destroy
    if @referential.rule_parameter_sets.count == 1
      flash[:alert] = "Suppression impossible, le referentiel doit compter au minimum un jeu de parametre."
      redirect_to referential_rule_parameter_sets_path( @referential )
    else
      destroy!
    end
  end

  protected

  alias_method :rule_parameter_set, :resource
end

