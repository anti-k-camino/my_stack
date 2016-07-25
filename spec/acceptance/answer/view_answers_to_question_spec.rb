require_relative  '../acceptance_helper'
feature "view question's answers", %q{
  In order to use this app propperly
  I want to get a question and see answers on it
}do
    
  given!(:question_with_answers) { create :question }    
  given!(:answers) { create_list(:answer, 2, question: question_with_answers) }
  context 'User choses a questions and see answer for chosen question which has answers' do

    scenario 'User sees the answers to chosen question', js: true do
      visit question_path question_with_answers
      expect(current_path).to eq question_path question_with_answers 
      expect(page).to have_content answers[0].body
      expect(page).to have_content answers[1].body 
    end 

  end
end