require_relative '../acceptance_helper'

feature 'user sign in', %q{
  Inorder to be able to ask question
  As a user
  I want to be able to sign in
} do
  given(:user){ create(:user) }

  scenario "Registered user try's to sign" do   
    visit root_path
    expect(page).to have_content "Sign in"
    sign_in user

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end 


  scenario "Non registered user try's to sign in" do
    visit new_user_session_path
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
#save_and_open_page
    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end