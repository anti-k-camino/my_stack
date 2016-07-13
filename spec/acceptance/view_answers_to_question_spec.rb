require 'rails_helper'
feature "view question's answers", %q{
  In order to use this app propperly
  I want to get a question and see answers on it
}do
    
  given!(:question_with_answers) { create :question }    
  given!(:answers) { create_list(:answer, 2, question: question_with_answers) }
  context 'User choses a questions and see answer for chosen question which has answers' do    
    scenario 'User sees the answers to chosen question' do
      visit question_path question_with_answers
      expect(current_path).to eq question_path question_with_answers
      expect(page).to have_selector 'div.answers'      
      expect(page).to have_content answers[0].body 
      expect(page).to have_content answers[1].body 
    end 
  end

  context 'User choses a questions and see answer for chosen question which has no answers' do
    given(:question_without_answers){ create :question }
    scenario 'User choses a question and see that the question is not answered yet' do
      
      visit question_path question_without_answers
      expect(current_path).to eq question_path question_without_answers
      expect(page).to have_content question_without_answers.title
      expect(page).to have_content question_without_answers.body        
      
      expect(page).to_not have_content answers[0].body 
      expect(page).to_not have_content answers[1].body
      within('div.answers') do     
        expect(page).to have_content 'No answers currently.'
      end
    end
  end
end