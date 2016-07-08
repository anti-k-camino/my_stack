require 'rails_helper'

feature 'Give an answer', %q{
  As a User
  I want to see the question
  I want to give an answer on that question
} do 
  given(:question){ create :question }
  scenario 'User creates an answer to a question' do
    question
    visit questions_path    
    click_on "#{question.title}"
    expect(current_path).to eq question_path question    
    click_on 'Answer'
    fill_in 'Body', with:'text text'
    click_on 'Create answer'   
    expect(current_path).to eq question_path question
    expect(page).to have_content('Your answer successfully added.')    
    expect(page).to have_content("#{ question.answers.last.body }")
  end
end