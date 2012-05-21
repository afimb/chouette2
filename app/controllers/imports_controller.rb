class ImportsController < ChouetteController
  respond_to :html, :xml, :json
  belongs_to :referential

  def create
    create! do |success, failure|
      success.html { redirect_to referential_imports_path(@referential) }
    end
  end

  protected

  def collection
    @imports ||= end_of_association_chain.paginate(:page => params[:page])
  end

end
