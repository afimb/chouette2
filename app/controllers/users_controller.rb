class UsersController < BreadcrumbController

  defaults :resource_class => User
  respond_to :html, :only => [:show]
  
  def destroy
    destroy! do |success, failure|
      success.html { redirect_to organisation_path }
    end
  end  

  protected

  def begin_of_association_chain
    current_organisation
  end

end
