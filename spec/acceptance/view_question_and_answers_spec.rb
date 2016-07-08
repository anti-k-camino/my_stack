require 'rails_helper'
feature "view question and question's answers", %q{
  In order to use this app propperly
  I want to get a question and see answers on it
} do
    given(:questions){ create_list(:question_with_answers, 2) }

    scenario 'User choses a questions one by one and sees answer for chosen question' do

      questions
      visit questions_path
      expect(current_path).to eq questions_path
      expect(page).to have_content questions[0].title 
      expect(page).to have_content questions[1].title 
      click_on "#{ questions[0].title }"      
      expect(current_path).to eq question_path(questions[0])
      expect(page).to have_content questions[0].body 
      expect(page).to_not have_content questions[1].body 
      expect(page).to have_content questions[0].answers[0].body 
      expect(page).to have_content questions[0].answers[1].body 
      visit question_path(questions[1])
      expect(current_path).to eq question_path(questions[1])
      expect(page).to have_content questions[1].body 
      expect(page).to_not have_content questions[0].body     
      expect(page).to have_content questions[1].answers[0].body 
      expect(page).to have_content questions[1].answers[1].body     
      
    end 
  
end