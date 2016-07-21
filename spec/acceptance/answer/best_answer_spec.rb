require_relative '../acceptance_helper'

feature 'answers order best', %q{
  In order to help users get best answer quicker
  As an authenticated user and  question author 
  I want to mark best answer
  } do
    given!(:user){ create :user }
    given!(:non_author){ create :user }
    given!(:question){ create :question, user: user }
    given!(:answer){ create :vote_answer, question: question }
    given!(:answer1){ create :vote_answer, question: question }
    given!(:best_answer){ create :vote_answer, question: question, best: true }

    scenario 'Non authenticted user can not vote for best answer' do
      visit question_path(question)
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content answer1.body
      expect(page).to have_content best_answer.body
      expect(page).to_not have_content "Vote"
    end

    scenario 'Non author authenticated user can not vote for best answer' do
      sign_in non_author
      visit question_path(question)
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content answer1.body
      expect(page).to have_content best_answer.body
      expect(page).to_not have_content "Vote"
    end

    context "Author of a question" do
      scenario 'can vote for answer  in question that not have been voted yet as best ', js: true do
        sign_in user
        visit question_path(question)        
        expect(page).to have_content answer.body 
        expect(page).to have_selector "#answer_#{ answer.id }"
        within("#answer_#{ answer.id }") do                           
          click_link "Vote"
          wait_for_ajax
          expect(page).to_not have_content "Vote"
        end      
        
      end
      scenario 'can vote for answer in question that was already voted' do
      end
    end
    
  end