 class RegistrationsController < Devise::RegistrationsController

   prepend_before_filter :accept_user_creation, :only => [:new, :create]

   private

   def accept_user_creation
     puts "J'y passe"
     if !Rails.application.config.accept_user_creation
       redirect_to root_path
       return false
     else
       return true
     end
   end
   
 end
