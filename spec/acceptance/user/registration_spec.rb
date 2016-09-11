require_relative '../acceptance_helper'

feature 'user can registrate' do 

  background do
    # will clear the message queue
    clear_emails
    
    # Will find an email sent to test@example.com
    # and set `current_email`
    
  end


  before do
    visit root_path
    click_on 'Register'
    expect(current_path).to eq new_user_registration_path
  end
 
  scenario 'unregistered user has ability to registrate' do
    
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'email@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with:'12345678'
    click_on 'Sign up'
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

    open_email('email@gmail.com')
    
    p ActionMailer::Base.deliveries.count    
    expect(current_email).to have_content 'Confirm my account'
  end



  scenario 'unregisterd user has ability to sign in with facebook' do       
    mock_auth_facebook_hash
    click_on 'Sign in with Facebook'    
    expect(page).to have_content "Successfully authenticated from Facebook account."
    expect(page).to have_content "Sign out"
    click_on 'Ask question'
    expect(current_path).to eq new_question_path
  end 

  scenario 'unregistered user has ability to sign in with twitter' do       
    mock_auth_twitter_hash    
    click_on 'Sign in with Twitter'    
    #binding.pry   
    fill_in 'Email', with: 'some@email.com'    
    click_on 'Continue' 
    expect(page).to have_content "Confirmation email was sent!"
       
  #  open_email('some@email.com')
        
  #  expect(current_email).to have_content "Confirm my account"
  end

  

end