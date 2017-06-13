require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

# Feature: User edit
#   As a user
#   I want to edit my user profile
#   So I can change my email address
feature 'User edit', :devise do

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User changes email address
  #   Given I am signed in
  #   When I change my email address
  #   Then I see an account updated message
  scenario 'user changes email address' do
    user = FactoryGirl.create(:user)
    user.confirm
    login_as(user, :scope => :user)
    visit edit_user_registration_path(user)
    fill_in 'user_email', :with => 'newemail@example.com'
    fill_in 'user_current_password', :with => user.password
    click_button I18n.t( 'devise.registrations.edit.commit')
    txts = [I18n.t( 'devise.registrations.updated'), I18n.t( 'devise.registrations.update_needs_confirmation')]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  # Scenario: User cannot edit another user's profile
  #   Given I am signed in
  #   When I try to edit another user's profile
  #   Then I see my own 'edit profile' page
  scenario "user cannot cannot edit another user's profile", :me do
    me = FactoryGirl.create(:user)
    me.confirm
    other = FactoryGirl.create(:user, email: 'other@example.com')
    other.confirm
    login_as(me, :scope => :user)
    visit edit_user_registration_path(other)
    expect(page).to have_content I18n.t( 'devise.registrations.edit.title')
    expect(page).to have_field('Email', with: me.email)
  end

end
