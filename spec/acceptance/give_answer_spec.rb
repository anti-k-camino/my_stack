require 'rails_helper'

feature 'Give an answer', %q{
  As a User
  I want to see the question
  I want to give an answer on that question
}, skip:true do; 
  given(:question){ create :question }
  before do
    question
    visit questions_path    
    click_on "#{ question.title }"
    expect(current_path).to eq question_path question    
    click_on 'Answer'
  end
  
  scenario 'User creates an answer to a question' do   
    fill_in 'Body', with:'text text'
    click_on 'Create answer'   
    expect(current_path).to eq question_path question
    expect(page).to have_content 'Your answer successfully added.'    
    expect(page).to have_content "#{ question.answers.last.body }"    
  end

  scenario 'User try to create a question with empty body' do    
    click_on 'Create answer'
    expect(current_path).to eq question_answers_path question
    expect(page).to have_content 'error'
  end

end