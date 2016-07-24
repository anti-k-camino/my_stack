require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question 
  As a question's author
  I'd like to be able to attach files
} do 

  given(:user){ create(:user) }

  background do
    sign_in user
    visit new_question_path
    fill_in "Title", with: "text question"
    fill_in "Body", with: "text text"
  end

  scenario 'User adds file when asks question' do    
    attach_file "File", "#{ Rails.root }/spec/spec_helper.rb"
    click_on "Create"

    expect(page).to have_link "spec_helper.rb", href:"/uploads/attachment/file/1/spec_helper.rb"
  end

  scenario 'User adds several files to question', js: true do    
    click_on "add file"
    files = all("input[type='file']")
      
    files[0].set("#{ Rails.root }/spec/spec_helper.rb")
    files[1].set("#{ Rails.root }/spec/rails_helper.rb")
     
      
    
    
    click_on "Create"
    save_and_open_page     
    expect(page).to have_link "spec_helper.rb", href:"/uploads/attachment/file/2/spec_helper.rb"
    expect(page).to have_link "rails_helper.rb", href:"/uploads/attachment/file/3/rails_helper.rb"
  end
end
