require_relative '../acceptance_helper'

feature 'Remove attached files from question', %q{
  In order to fix mistakes
  As an author of a question 
  I want to remove attached files
} do 
  given(:user){ create :user }
  given!(:question){ create :question, user: user }
  given!(:attachment) { create(:attachment, attachable: question) }
  given!(:attachment_another) { create(:attachment, file: File.open("#{ Rails.root }/spec/rails_helper.rb"), attachable: question) }
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
    expect(page).to_not have_content attachment.file.filename
    click_on "Update" 
    expect(page).to_not have_link attachment.file.filename
  end

  scenario 'Author of a question can remove one attached file and left the other', js: true do    
    within('.show_question') do
      expect(page).to have_link attachment.file.filename
      expect(page).to have_link attachment_another.file.filename 
      click_on 'Edit'          
    end     
    within("#attachment_#{ attachment.id }") do      
      click_on 'Remove'      
    end 
        
    expect(page).to_not have_content attachment.file.filename     
    within("#attachment_#{ attachment_another.id }") do      
      expect(page).to have_content attachment_another.file.filename      
    end        
    click_on "Update"
    wait_for_ajax 
    expect(page).to_not have_link attachment.file.filename
    expect(page).to have_link attachment_another.file.filename
  end

  
end
  
