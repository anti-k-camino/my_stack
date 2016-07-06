require 'rails_helper'

feature 'user sign in', %q{
  Inorder to be able to ask question
  As a user
  I want to be able to sign in
} do
  scenario "Registered user try's to sign in" do
    User.create!(name: 'AntonioMontana', email:'user@test.com', password:'12345678')

    visit new_user_session_path
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

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