require 'rails_helper'

feature 'User can delete a question', %q{
  In order to manage my publications
  As an authenticated user and author of a question
  I want to delete a question
} do
  context 'Athenticated user wants to delete a question' do
    given(:user){ create :user }
    given(:malicious_user){ create :user }
    given(:question){ create :question, user: user }    
    
    scenario 'Author of a question deletes a question' do            
      sign_in user         
      visit question_path question
      within("//p[class='question']"){ click_on 'Delete' }             
      expect(page).to have_content 'Question successfully destroyed.'
      expect(current_path).to eq questions_path      
    end
    scenario 'Not the author of a question try to delete a question' do
      sign_in malicious_user
      visit question_path question       
      within("//p[class='question']"){ expect(page).to_not have_content 'Delete' }              
    end
  end
  scenario 'Non authenticated user wants to delete a question' do
  end
end