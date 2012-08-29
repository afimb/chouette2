class SubscriptionsController < Devise::RegistrationsController
  
  def new
    @subscription = Subscription.new
  end
  def create
    @subscription = Subscription.new(params[:subscription])

    if @subscription.save
      sign_in @subscription.user
      flash[:notice] = t('subscriptions.success')
      redirect_to referentials_path
    else
      flash[:error] = t('subscriptions.failure')
      render :action => "new"
    end
  end

end

