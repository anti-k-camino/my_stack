require_relative '../acceptance_helper'
feature 'Add files to answer', %q{
  In order to iluustrate my answer
  As an answer author
  I would like to be able to attach files
} do 
  given(:user){ create(:user) }
  given(:question){ create(:question) } 

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds file when gives an answer', js: true do
    within('div.create_answer') do
      fill_in 'Body', with: 'answer body'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb" 
      click_on "Create answer"       
    end
    within(".answers") do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    end
  end

   scenario 'User adds several files when gives an answer', js: true do
    click_on 'add file'
    wait_for_ajax    
    within('div.create_answer') do
      fill_in 'Body', with: 'answer body'
      files = page.all("input[type='file']")       
      files[0].set("#{ Rails.root }/spec/spec_helper.rb")
      files[1].set("#{ Rails.root }/spec/rails_helper.rb")  
      click_on "Create answer"
      wait_for_ajax       
    end
    within(".answers") do      
      expect(page).to have_link "spec_helper.rb", href:"/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href:"/uploads/attachment/file/2/rails_helper.rb"
    end
  end
end