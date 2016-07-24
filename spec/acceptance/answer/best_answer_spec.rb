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

    scenario 'Best answer is shown first' do
      visit question_path(question)
      within('.answers') do
        answers_all = page.all("div")
        expect(answers_all[0][:id]).to eq "answer_dom_#{ best_answer.id }"
      end
    end

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
      before do
        sign_in user
        visit question_path(question)        
        expect(page).to have_content answer.body 
        expect(page).to have_selector "#answer_#{ answer.id }"
      end
      scenario 'can vote for answer  in that not have been voted yet as best ', js: true do        
        within("#answer_#{ answer.id }") do                           
          click_link "Vote"
          wait_for_ajax
          expect(page).to_not have_content "Vote"                
        end         
      end
      scenario 'best answer after vote is shown first', js: true do
        within('.answers') do
          answers_all = page.all("div")
          expect(answers_all[0][:id]).to eq "answer_dom_#{ best_answer.id }"
        end
        within("#answer_#{ answer.id }") do                           
          click_link "Vote"
          wait_for_ajax
          expect(page).to_not have_content "Vote"                
        end
        within('.answers') do
          answers_all = page.all("div")
          expect(answers_all[0][:id]).to eq "answer_dom_#{ answer.id }"
        end
        within("#answer_#{ answer.id }") do           
          expect(page).to_not have_content "Vote"                   
        end
      end
      scenario 'can not vote for answer that was already voted', js: true do
        within("#answer_#{ best_answer.id }") do           
          expect(page).to_not have_content "Vote"                   
        end
      end

    end
    
  end