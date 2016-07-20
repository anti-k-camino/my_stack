require_relative '../acceptance_helper'
feature "view question and question's answers", %q{
  In order to use this app propperly
  I want to get a question and see details
} do
    given!(:questions) { create_list :question, 2 }    
    given!(:user){ create :user } 
  context 'User choses a questions and see answer for chosen question which has answers' do
    scenario 'Authenticated user visits a question which has answers' do 
      sign_in user     
      visit questions_path      
      expect(current_path).to eq questions_path  
      expect(page).to have_content "#{ questions[0].title }"
      expect(page).to have_content "#{ questions[1].title }"   
      click_on "#{ questions[0].title }"           
      expect(current_path).to eq question_path questions[0]
      expect(page).to have_content questions[0].title
      expect(page).to have_content questions[0].body
      expect(page).to have_content questions[0].body 
      expect(page).to_not have_content questions[1].body               
    end
    scenario 'Non-authenticated user visits a question which has answers' do          
      visit questions_path      
      expect(current_path).to eq questions_path  
      expect(page).to have_content "#{ questions[0].title }"
      expect(page).to have_content "#{ questions[1].title }"   
      click_on "#{ questions[0].title }"           
      expect(current_path).to eq question_path questions[0]
      expect(page).to have_content questions[0].title
      expect(page).to have_content questions[0].body
      expect(page).to have_content questions[0].body 
      expect(page).to_not have_content questions[1].body               
    end
  end  
end