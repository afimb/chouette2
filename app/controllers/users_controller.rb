class UsersController < BreadcrumbController
  before_action :check_authorize, except: [:show, :index]

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

  def role_edit
    return unless current_user.admin?
    @user = User.find(params[:id])
  end

  def role_update
    return unless current_user.admin?
    update! do |success, failure|
      success.html { redirect_to organisation_user_path(@user) }
    end
  end

  private

  def user_params
    permit_params = [ :id, :name, :email ]
    permit_params << :role if current_user.admin?
    params.require(:user).permit( permit_params )
  end

end
