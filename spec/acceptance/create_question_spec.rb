require 'rails_helper'

feature 'create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask questions
} do 
  given(:user){ create :user }
  scenario 'Authenticated user creates question' do 
    sign_in user     

    visit questions_path
    click_on 'Ask question'
    
    fill_in 'Title', with:'test question'
    fill_in 'Body', with:'text text'
    click_on 'Create'
    expect(page).to have_content('Your question successfully created.')
  end
  scenario 'Non authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end