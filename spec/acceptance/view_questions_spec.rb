require 'rails_helper'
feature 'User gets list of questions', %q{
  In order to be able to answer a question
  Or on order to get an answer for existiong question
  As an unregistered user 
  I want to be able to see list of existing questions
} do   
  scenario 'Unregistered user try to get the list of questions' do
    visit questions_path
    expect(page).to have_current_path questions_path    
    expect(page).to have_selector 'ul'
  end
end