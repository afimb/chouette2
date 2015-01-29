 class RegistrationsController < Devise::RegistrationsController

   prepend_before_filter :accept_user_creation, :only => [:new, :create]

   protected

   # The default url to be used after updating a resource. You need to overwrite
   # this method in your own RegistrationsController.
   def after_update_path_for(resource)
     organisation_user_path(resource)
   end
   
   def sign_up_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation, { organisation_attributes: [:name] } )
   end
   
   def account_update_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
   end

   
   private

   def accept_user_creation
     if !Rails.application.config.accept_user_creation
       redirect_to unauthenticated_root_path
       return false
     else
       return true
     end
   end     
   
 end
