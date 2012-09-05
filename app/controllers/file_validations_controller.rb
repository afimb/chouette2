class FileValidationsController < InheritedResources::Base
  respond_to :html, :xml, :json

  def show
    @toc = TestSheetPage.find("toc")
    show!
  end
  
  def new
    @toc = TestSheetPage.find("toc")
    new!
  end

  def create
    create! do |success, failure|
      success.html { redirect_to file_validations_path }
    end
  end

  protected
  def resource
    @file_validation ||= current_organisation.file_validations.find_by_id(params[:id])
  end
  def collection    
    @file_validations ||= current_organisation.file_validations.paginate(:page => params[:page])
  end
  def create_resource(file_validation)
    file_validation.organisation = current_organisation
    super
  end
  
end
