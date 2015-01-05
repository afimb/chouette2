module DeviseRequestHelper
  include Warden::Test::Helpers

  def login_user
    organisation = Organisation.where(:name => "first").first_or_create(attributes_for(:organisation))
    @user ||= create(:user, :organisation => organisation)
    @user.confirm!
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

module DeviseControllerHelper
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      organisation = Organisation.where(:name => "first").first_or_create(attributes_for(:organisation))
      user = create(:user, :organisation => organisation)
      user.confirm!
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseControllerHelper, :type => :controller

  config.include DeviseRequestHelper, :type => :request
  config.include DeviseRequestHelper, :type => :feature
end
