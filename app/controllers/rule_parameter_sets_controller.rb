class RuleParameterSetsController < BreadcrumbController
  defaults :resource_class => RuleParameterSet
  respond_to :html
  respond_to :js, :only => [ :mode ]

  def new
    @rule_parameter_set = RuleParameterSet.default( current_organisation)
    new! do
      build_breadcrumb :new
    end
  end


  def destroy
    if current_organisation.rule_parameter_sets.count == 1
      flash[:alert] = t('rule_parameter_sets.destroy.last_rps_protected')
      redirect_to organisation_rule_parameter_sets_path
    else
      destroy! do |success, failure|
        success.html { redirect_to organisation_rule_parameter_sets_path }
      end
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to organisation_rule_parameter_sets_path }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to organisation_rule_parameter_sets_path }
    end
  end

  protected

  alias_method :rule_parameter_set, :resource

  def collection
    @rule_parameter_sets = current_organisation.rule_parameter_sets
  end

  def create_resource(rule_parameter_sets)
    rule_parameter_sets.organisation = current_organisation
    super
  end
end

