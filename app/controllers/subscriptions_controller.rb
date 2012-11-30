class SubscriptionsController < InheritedResources::Base
  skip_filter :authenticate_user!
  
  def create
    create! do |success|
      success.html do
        sign_in resource.user
        redirect_to referentials_path
      end
    end
  end

end

