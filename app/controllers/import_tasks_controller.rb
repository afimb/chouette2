class ImportTasksController < ChouetteController
  defaults :resource_class => ImportTask
  respond_to :html, :xml, :json
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  def new
    new! do
      build_breadcrumb :show
      available_imports
    end
  end

  def show
    show! do
      build_breadcrumb :show
      if import_task.completed?
        @files_stats = import_task.result["files"]["stats"]
        @files_list = import_task.result["files"]["list"]
        @lines_stats = import_task.result["lines"]["stats"]
        @lines_list = import_task.result["lines"]["list"]
      end
    end
  end

  def file_to_import
    send_file import_task.file_path, :type => "application/#{import_task.file_path_extension}", :disposition => "attachment"
  end

  def create
    create!  do |success, failure|
      available_imports
      success.html { flash[:notice] = I18n.t('import_tasks.new.flash'); redirect_to referential_import_tasks_path(@referential) }
    end
  end

  protected

  def create_resource( import )
    if import_task.save
      import_task.delayed_import
    end
  end

  alias_method :import_task, :resource

  def available_imports
    @available_imports ||= ImportTask.formats.collect do |format|
      unless @import_task.format == format
        @referential.import_tasks.build :format => format
      else
        @import_task
      end
    end
  end

  # FIXME why #resource_id is nil ??
  def build_resource
    super.tap do |import_task|
      import_task.referential_id = @referential.id
      import_task.user_id = current_user.id
      import_task.user_name = current_user.name
    end
  end

  def collection
    @import_tasks ||= end_of_association_chain.order('created_at DESC').paginate(:page => params[:page])
  end

end
