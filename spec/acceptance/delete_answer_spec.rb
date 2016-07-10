require 'rails_helper'

feature 'User can delete an answer', %q{
  In order to manage my publications
  As an authenticated user and author of an answer
  I want to delete an answer
} do
  context 'Athenticated user wants to delete an answer' do
    given(:user){ create :user }
    given(:malicious_user){ create :user }
    given(:question){ create :question }
    given(:answer){ create :answer, question: question, user: user }    
    
    scenario 'Author of an answer deletes an answer' do 
      question
      answer            
      sign_in user
      visit question_path question        
      within("//p[class='answer']"){ click_on 'Delete' }
      expect(page).to have_content 'Answer successfully destroyed.'
      expect(current_path).to eq question_path question      
    end

    scenario 'Not the author of a question try to delete a question' do
      question
      answer
      sign_in malicious_user
      visit question_path question       
      within("//p[class='answer']"){ expect(page).to_not have_content 'Delete' }              
    end
  end
   
end