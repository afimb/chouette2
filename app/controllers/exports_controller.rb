class ExportsController < ChouetteController

  respond_to :html, :xml, :json
  respond_to :zip, :only => :show

  belongs_to :referential

  def create
    create! do |success, failure|
      success.html { redirect_to referential_exports_path(@referential) }
    end
  end

  def show
    show! do |format|
      format.zip { send_file @export.file, :type => :zip }
    end
  end


  protected

  # FIXME why #resource_id is nil ??
  def build_resource
    super.tap do |export|
      export.referential_id = @referential.id
    end
  end

  def collection
    @exports ||= end_of_association_chain.paginate(:page => params[:page])
  end

end
