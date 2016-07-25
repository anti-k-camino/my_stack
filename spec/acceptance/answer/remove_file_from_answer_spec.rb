require_relative '../acceptance_helper'

feature 'Remove attached files from answer', %q{
  In order to fix mistakes
  As an author of an answer 
  I want to remove attached files
} do 
 
  given!(:user){ create :user }
  given!(:question){ create :question }
  given!(:answer){ create :answer, question: question, user: user }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given!(:attachment_another) { create(:attachment, file: File.open("#{ Rails.root }/spec/rails_helper.rb"), attachable: answer) }
  
  before do
    sign_in user
    visit question_path(question)
    wait_for_ajax     
  end
  scenario 'When editing answer author of an answer can remove attached files', js: true do    
    within('.answers') do          
      expect(page).to have_link attachment.file.filename 
      click_on 'Edit' 
      wait_for_ajax          
    end          
    within("#attachment_#{ attachment.id }") do 
      wait_for_ajax     
      click_on 'Remove'
      wait_for_ajax       
    end  
    wait_for_ajax   
    expect(page).to_not have_link attachment.file.filename
    click_on "Edit" 
    wait_for_ajax 
    expect(page).to_not have_link attachment.file.filename
  end

  scenario 'Author of a question can remove one attached file and left the other', js: true do
    
    within('.answers') do
      expect(page).to have_link attachment.file.filename
      expect(page).to have_link attachment_another.file.filename 
      click_on 'Edit'
      wait_for_ajax          
    end     
    within("#attachment_#{ attachment.id }") do      
      click_on 'Remove'
      wait_for_ajax
    end
    expect(page).to_not have_content attachment.file.filename
    expect(page).to have_content attachment_another.file.filename
    within("#edit_answer#{ answer.id }") do
      click_on "Edit"
    end
    wait_for_ajax 
    expect(page).to_not have_link attachment.file.filename
    expect(page).to have_link attachment_another.file.filename
  end

  
end
  
