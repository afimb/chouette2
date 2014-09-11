class ComplianceCheckTasksController < ChouetteController
  respond_to :html, :js
  belongs_to :referential

  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)
    end
  end

  def show
    show! do
      add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)
    end
  end
  def references
    @references = referential.send(params[:type]).where("name ilike ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json do
        render json: @references.collect { |child| { id: child.id, name: child.name } }
      end
    end
  end

  def rule_parameter_set
    @rule_parameter_set = compliance_check_task.rule_parameter_set_archived
    render "rule_parameter_sets/show"
  end

  def create
    create!  do |success, failure|
      success.html { flash[:notice] = I18n.t('compliance_check_tasks.new.flash'); redirect_to referential_compliance_check_tasks_path(@referential) }
    end
  end

  protected

  alias_method :compliance_check_task, :resource

  def create_resource( object )
    if object.save
      object.delayed_validate
    end
  end

  def build_resource
    super.tap do |export|
      compliance_check_task.assign_attributes referential_id: @referential.id,
        user_id: current_user.id,
        user_name: current_user.name
    end
  end

  def collection
    @compliance_check_tasks ||= end_of_association_chain.order('created_at DESC').paginate(page: params[:page])
  end

end
