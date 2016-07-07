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
    
    click_on 'Answer'

    fill_in 'Body', with:'text text'
    click_on 'Create answer'    
    expect(page).to have_content('Your answer successfully added.')
  end
end