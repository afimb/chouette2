class FileValidationsController < InheritedResources::Base
  respond_to :html, :xml, :json

  def index
    no_referential
    index!
  end

  def show
    no_referential
    @toc = TestSheetPage.find("toc")
    show!
  end
  
  def new
    no_referential
    @toc = TestSheetPage.find("toc")
    new!
  end

  def create
    no_referential
    create! do |success, failure|
      success.html { redirect_to file_validations_path }
    end
  end

  
  protected
  def no_referential
    Apartment::Database.switch("public")
  end
  
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
