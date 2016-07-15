require 'rails_helper'
feature 'answer aquestion', %q{
  As an authenticated User
  I want to give an answer to a question
} do
  given!(:question){ create :question } 
  given(:user){ create :user }  
  context 'Authenticated user creates answer' do

    scenario 'Authenticated user whants to create a question', js: true do
      sign_in user 
      visit question_path question            
      within('div.create_answer') do  
        expect(page).to have_button 'Create answer' 
      end   
      fill_in 'Body', with: 'example answer'    
      click_on 'Create answer'
      expect(current_path).to eq question_path question              
      expect(page).to have_content 'example answer'             
    end

    scenario 'Authenticated user whants to create an empty question', js: true do
      sign_in user 
      visit question_path question            
      within('div.create_answer') do  
        expect(page).to have_button 'Create answer' 
      end        
      click_on 'Create answer'
      expect(current_path).to eq question_path question
      expect(page).to have_content "Body can't be blank"
    end
  end



  context 'Non authenticated user creates answer' do  #temporary test

    scenario 'Non authenticated user whants to create an answer', js: true do
      visit question_path question       
      fill_in 'Body', with: 'example answer'     
      expect(page).to_not have_content 'Create answer'        
    end
  end
end