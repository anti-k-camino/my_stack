require_relative '../acceptance_helper'

feature 'Remove attached files from question', %q{
  In oreder to fix mistakes
  As an author of a question 
  I want to remove attached files
} do 
  given!(:user){ create :user }
  given!(:question){ create :question, user: user }
  given!(:attachment) { create(:attachment, attachable: question) }
  given!(:attachment_another) { create(:attachment, attachable: question) }
  background do
    sign_in user
    visit question_path(question)
  end
  scenario 'When editing question author of a question can remove attached files', js: true do
    within('.show_question') do
      expect(page).to have_link attachment.file.filename 
      click_on 'Edit'          
    end     
    within("#attachment_#{ attachment.id }") do      
      click_on 'Remove'
      wait_for_ajax
    end 
    expect(page).to_not have_link attachment.file.filename
    click_on "Update" 
    expect(page).to_not have_link attachment.file.filename
  end

  scenario 'Not author of a question can not remove attached files', js: true do
    
    within('.show_question') do
      expect(page).to have_link attachment.file.filename
      expect(page).to have_link attachment_another.file.filename 
      click_on 'Edit'          
    end     
    within("#attachment_#{ attachment.id }") do      
      click_on 'Remove'
      wait_for_ajax
    end
    expect(page).to_not have_link attachment.file.filename
    expect(page).to_not have_link attachment_another.file.filename
    click_on "Update" 
    expect(page).to_not have_link attachment.file.filename
    expect(page).to_not have_link attachment_another.file.filename
  end

  
end
  
