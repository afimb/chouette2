class UsersController < BreadcrumbController

  skip_before_action :check_organisation
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
  
  def additionnal_fields
    @user = current_user
  end
  
  def save_additionnal_fields
    @user = current_user
    @user.organisation = Organisation.new
    @user.organisation.name = params[:user][:organisation]
    
    if @user.organisation.name.present?
      if @user.save(:validate => false)
        redirect_to root_path
      else
        render :additionnal_fields
      end
    else
      @user.organisation = nil
      @user.errors.add(:organisation, "Le champ Organisation doit être rempli")
      render :additionnal_fields
    end
  end

  private
  def user_params
    params.require(:user).permit( :id, :name, :email, :provider, :uid )
  end

end
