require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistakes
  As an author of a question
  I want to be able to edit question
} do
  given(:user){ create(:user) }
  given(:user_non_author){ create(:user) }
  given!(:question){ create(:question, user: user) }  
  given!(:answer){ create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
  
  context 'Authenticated user' do
    scenario 'Author when trying to edit question sees link to edit' do
      sign_in user
      visit question_path(question)
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Non-author does not see link to edit' do
      sign_in user_non_author
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end


    context "Author try's to edit question" do      
      before(:each) do
        sign_in user
        visit question_path(question)
      end

      scenario 'with valid attributes', js: true do          
        within ".question" do
          expect(page).to_not have_content 'textarea'
        end
        within ".question" do
          expect(page).to have_content question.title
          expect(page).to have_content question.body
          click_on 'Edit'        
        end 
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector ".show_question"       
        within ".question" do
          expect(page).to have_selector "textarea" 
          fill_in :question_title, with: "edited title"       
          fill_in :question_body, with: "edited body"
          click_on 'Update'
        end 
        within ".question" do
          expect(page).to_not have_selector 'textarea'
        end
        expect(page).to have_content "edited title"  
        expect(page).to have_content "edited body"
      end

=begin
    scenario "can't update two objects at one time", js: true do
        expect(page).to have_selector ".show_question"     
        expect(page).to have_selector "#show_answer#{ answer.id }"
        within ".question" do
          expect(page).to have_content question.body
          click_on 'Edit'                  
        end
        expect(page).to_not have_selector ".show_question"
        within '.answers' do
          expect(find('a',text: "Edit").click).to raise_error('Failed to click element')
        end                   
        expect(page).to_not have_selector "#edit_answer#{ answer.id }"
      end
=end


      scenario 'with invalid attributes', js: true do       
        within ".question" do
          expect(page).to_not have_content 'textarea'
        end
        within ".question" do
          expect(page).to have_content question.title
          expect(page).to have_content question.body
          click_on 'Edit'        
        end         
        within ".question" do
          fill_in 'question_title', with: ''           
          fill_in 'question_body', with: ''
          click_on 'Update'
        end
        expect(page).to have_content "Title can't be blank"  
        expect(page).to have_content "Body can't be blank" 
        within ".question" do          
          expect(page).to have_selector 'textarea'
        end        
      end

    end

 
  end
end
