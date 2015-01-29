class OrganisationsController < BreadcrumbController

  defaults :resource_class => Organisation
  respond_to :html, :only => [:edit, :show, :update]

  def update
    update! do |success, failure|
      success.html { redirect_to organisation_path }
    end
  end

  private

  def resource
    @organisation = current_organisation
  end

  def organisation_params
    params.require(:organisation).permit(:name)
  end
  
end

