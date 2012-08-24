class UserMailer < ActionMailer::Base
  default :from => 'sim@dryade.net'
  
  def welcome(user)
    @user = user
    mail(:subject => "Welcome to #{user.organisation.name}",
         :to => user.email)
  end

end

