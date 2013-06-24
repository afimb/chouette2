class SubscriptionsController < InheritedResources::Base
  skip_filter :authenticate_user!
  
  def create
    create! do |success, failure|
      success.html do
        sign_in resource.user
        redirect_to referentials_path
      end
    end
  end

end

