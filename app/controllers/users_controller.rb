class UsersController < BreadcrumbController

  defaults :resource_class => User

  def create
    @user = current_organisation.users.build(user_params)

    if @user.valid?
      @user.invite!
      respond_with @user, :location => organisation_user_path(@user)
    else
      render :action => 'new'
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to organisation_user_path(@user) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to organisation_path }
    end
  end

  private
  def user_params
    params.require(:user).permit( :id, :name, :email )
  end

end
