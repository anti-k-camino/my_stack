require 'rails_helper'
feature "view question and question's answers", %q{
  In order to use this app propperly
  I want to get a question and see answers on it
} do
    given(:questions) { create_list :question, 2 }
    given!(:question) { questions[0] }
    given!(:answers) { create_list(:answer, 2, question: question) }
  context 'User choses a questions and see answer for chosen question which has answers' do
    scenario 'Authenticated user visits a question which has answers' do      
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
    scenario 'User sees the answers to chosen question' do
      visit question_path question
      expect(current_path).to eq question_path question
      expect(page).to have_content answers[0].body 
      expect(page).to have_content answers[1].body 
    end 
  end
  context 'User choses a questions and see answer for chosen question which has answers' do
    scenario 'User choses a question and see that the question is not answered yet' do
      visit question_path(questions[1])
      expect(current_path).to eq question_path questions[1]
      expect(page).to have_content questions[1].title
      expect(page).to have_content questions[1].body 
      expect(page).to_not have_content questions[0].body      
      expect(page).to_not have_selector 'div.answers'
      expect(page).to_not have_content answers[0].body 
      expect(page).to_not have_content answers[1].body     
      expect(page).to have_content 'No answers currently.'
    end
  end  
end