class UsersController < InheritedResources::Base

  def create
    @user = current_organisation.users.build(params[:user])

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

  protected

  def begin_of_association_chain
    current_organisation
  end

end
