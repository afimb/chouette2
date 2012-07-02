class FileValidationsController < InheritedResources::Base
  respond_to :html, :xml, :json


  def create
    create! do |success, failure|
      success.html { redirect_to file_validations_path }
    end
  end

  protected

  def collection
    @file_validations ||= end_of_association_chain.paginate(:page => params[:page])
  end

end
