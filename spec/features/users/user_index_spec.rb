require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

# Feature: User index page
#   As a user
#   I want to see a list of users
#   So I can see who has registered
feature 'User index page', :devise do

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User listed on index page
  #   Given I am signed in
  #   When I visit the user index page
  #   Then I see my own email address
  scenario 'user sees own email address' do
    user = create(:user)
    user.confirm!
    login_as(user, scope: :user)
    visit organisation_path
    expect(page).to have_content user.name.truncate(15)
  end

end
