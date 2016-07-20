require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistakes
  As an author of an answer
  I want to be able to edit answer
} do
  given(:user){ create(:user) }
  given(:user_non_author){ create(:user) }
  given!(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question, user: user) }
  given!(:more_answer){ create(:answer, question: question, user: user) }  

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
  
  context 'Authenticated user' do

    scenario 'Author when trying to edit answer sees link to edit' do
      sign_in user
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Non-author does not see link to edit' do
      sign_in user_non_author
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    context "Author try's to edit answer" do      
      before(:each) do
        sign_in user
        visit question_path(question)
      end

      scenario 'with valid attributes', js: true do          
        within "#answer_#{ answer.id }" do
          expect(page).to_not have_content 'textarea'
        end
        within "#show_answer#{ answer.id }" do
          expect(page).to have_content answer.body
          click_on 'Edit'        
        end 
        expect(page).to_not have_content answer.body
        within "#edit_answer#{ answer.id }" do
          expect(page).to have_selector "textarea"        
          fill_in :answer_body, with: "edited message"
          click_on 'Edit'
        end 
        within ".answers" do
          expect(page).to_not have_selector 'textarea'
        end  
        expect(page).to have_content "edited message"
      end

      scenario "can't update two answers at one time" do
        expect(page).to have_selector "#show_answer#{ answer.id }"     
        expect(page).to have_selector "#show_answer#{ more_answer.id }"
        within "#show_answer#{ answer.id }" do
          expect(page).to have_content answer.body
          click_on 'Edit'                  
        end
        expect(page).to_not have_selector "#show_answer#{ more_answer.id }"                  
        expect(page).to_not have_selector "#edit_answer#{ more_answer.id }"
      end

      scenario 'with invalid attributes', js: true do       
        within "#answer_#{ answer.id }" do
          expect(page).to_not have_content 'textarea'
        end
        within "#show_answer#{ answer.id }" do
          expect(page).to have_content answer.body
          click_on 'Edit'        
        end 
        expect(page).to_not have_content answer.body
        within "#edit_answer#{ answer.id }" do          
          fill_in 'answer_body', with: ''          
          click_on 'Edit'
        end 
        expect(page).to have_content "Body can't be blank" 
        within "#answer_#{ answer.id }" do          
          expect(page).to have_selector 'textarea'
        end        
      end

    end    
  end
end