require_relative '../acceptance_helper'

feature 'user can registrate' do
  given(:user){ create :user }

  background do
    # will clear the message queue
    clear_emails
    
    # Will find an email sent to test@example.com
    # and set `current_email`
    
  end

  scenario 'unregistered user has ability to registrate' do
    visit root_path
    expect(page).to have_content 'Register' # /register/i
    click_on 'Register'
    expect(current_path).to eq new_user_registration_path
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'email@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with:'12345678'
    click_on 'Sign up'
    expect(current_path).to eq root_path
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'
    open_email('email@gmail.com')
    save_and_open_page
    expect(current_email).to have_content 'click'
  end  
end