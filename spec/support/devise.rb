module DeviseRequestHelper
  include Warden::Test::Helpers

  def login_user
    @user ||= FactoryGirl.create :user
    login_as @user, :scope => :user
    # post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods

    def login_user
      before(:each) do
        login_user
      end
      after(:each) do
        Warden.test_reset!            
      end
    end

  end

end

module DeviseControllerhelper
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in Factory.create(:user)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseControllerhelper, :type => :controller

  config.include DeviseRequestHelper, :type => :request
end
