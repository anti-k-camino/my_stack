require_relative '../acceptance_helper'

feature 'user can registrate' do
  given(:user){ create :user }

  #background do
    # will clear the message queue
    #clear_emails
    
    # Will find an email sent to test@example.com
    # and set `current_email`
    
  #end
=begin  
  scenario 'unregistered user has ability to registrate' do
    visit root_path
    #expect(page).to have_content 'Register' # /register/i
    click_on 'Register'
    expect(current_path).to eq new_user_registration_path
    fill_in 'Name', with: 'AntonioMontana'
    fill_in 'Email', with: 'email@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with:'12345678'
    click_on 'Sign up'
    #sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

    open_email('email@gmail.com')
    
    #p ActionMailer::Base.deliveries.count    
    expect(current_email).to have_content 'Confirm my account'
  end 
=end
=begin  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end
=end

  before do
    visit root_path
    click_on 'Register'
    expect(current_path).to eq new_user_registration_path
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
    fill_in 'Email', with: 'some@email.com'
    click_on 'Continue'
    sleep 2
    open_email('some@email.com')    
    expect(current_email).to have_content "Confirm my account"
  end
end