class UsersController < InheritedResources::Base

  def create
        Rails.logger.info( "call user_controller.create")
        Rails.logger.info( "resource=#{build_resource.inspect}")
        Rails.logger.info( "resourc.valid?e=#{build_resource.valid?}")
        Rails.logger.info( "resourc.errors=#{build_resource.errors.inspect}")
    create! do |success, failure|
      success.html { 
        Rails.logger.info( "success user_controller")
        mail = UserMailer.welcome(@user)
        mail.deliver
        redirect_to organisation_user_path(@user) }
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
