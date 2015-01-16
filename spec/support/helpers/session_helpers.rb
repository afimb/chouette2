module Features
  module SessionHelpers
    def sign_up_with(email, password, confirmation)
      visit new_user_session_path
      within(".registration_new") do
        fill_in 'user_organisation_attributes_name', with: "Cityway"
        fill_in 'user_name', with: "User"
        fill_in 'user_email', with: email
        fill_in 'user_password', with: password
        fill_in 'user_password_confirmation', :with => confirmation
      end
      click_button 'S\'inscrire'
    end

    def signin(email, password)
      visit new_user_session_path
      within(".session_new") do
        fill_in 'user_email', with: email
        fill_in 'user_password', with: password       
      end
      click_button 'Se connecter'
    end
  end
end
