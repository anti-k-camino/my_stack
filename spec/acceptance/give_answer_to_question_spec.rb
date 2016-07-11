require 'rails_helper'
feature 'answer aquestion', %q{
  As an authenticated User
  I want to give an answer to a question
} do
  given!(:question){ create :question } 
  given(:user){ create :user }  
  context 'Authenticated user creates answer' do
    scenario 'Authenticated whants to create a question' do
      sign_in user 
      visit question_path question            
      within('div.create_answer') do  
        expect(page).to have_button 'Create answer' 
      end   
      fill_in 'Body', with: 'example answer'    
      click_on 'Create answer'
      expect(current_path).to eq question_path question
      expect(page).to have_content 'Your answer successfully added.'
      expect(page).to have_content 'example answer'   
    end
  end
  context 'Non authenticated user creates question' do
    given(:not_auth_user){ create :user }
    scenario 'Non authenticated user whants to create an answer' do
      visit question_path question           
      within('div.create_answer') do  
        expect(page).to have_button 'Create answer' 
      end   
      fill_in 'Body', with: 'example answer'    
      click_on 'Create answer'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq new_user_session_path 
      visit question_path question
      expect(page).to_not have_content 'example answer'
    end
  end
end