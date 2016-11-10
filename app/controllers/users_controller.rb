class UsersController < BreadcrumbController
  before_action :check_authorize, except: [:show, :index, :additionnal_fields, :save_additionnal_fields]
  before_action :authenticate_user!, except: [:additionnal_fields, :save_additionnal_fields]
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
    @user = User.new
    @user.organisation = Organisation.new
    @user.email = session['user_stand_by_email'] if session['user_stand_by_email'].present?
  end
  
  def save_additionnal_fields
    @user = User.new
    @user.provider = session['user_stand_by_provider']
    @user.uid = session['user_stand_by_uid']
    @user.password = Devise.friendly_token[0,20]
    @user.email = params[:user][:email]
    @user.name = session['user_stand_by_name']
    @user.organisation = Organisation.new
    @user.organisation.name = params[:user][:organisation_attributes][:name]
    
    if @user.valid?
      @user.confirm!
      @user.save
      sign_in @user
      redirect_to root_path
    else
      render :additionnal_fields
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
    permit_params = [ :id, :name, :email, :provider, :uid ]
    permit_params << :role if current_user.admin?
    params.require(:user).permit( permit_params )
  end

end
