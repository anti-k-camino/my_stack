require_relative '../acceptance_helper'
feature 'Vote for answer', %q{
  In order to match the best answer
  as an authenticated user
  and not the author of a answer
  I want to vote for a answer
}do
  context 'Non authenticated user' do
    given!(:question){ create :question }
    given!(:answer){ create :answer , question: question }
    scenario 'can not vote for an answer' do
      visit question_path(question)
      within('.answers') do        
        expect(page).to_not have_link "Up", href: upvote_question_path(question)
        expect(page).to_not have_link "Down", href: downvote_question_path(question)
      end      
    end
  end
  context 'Authenticated user' do
    context 'author of an answer' do
      given(:user){ create(:user) }
      given!(:question){ create :question }
      given!(:answer){ create :answer, question: question, user: user }

      scenario 'can not see links to vote' do
        sign_in user
        visit question_path(question)
        within('.answers') do     
          expect(page).to_not have_link "Up", href: upvote_question_path(question)
          expect(page).to_not have_link "Down", href: downvote_question_path(question)
        end
      end
    end

    context 'not author of an answer' do
      given(:user){ create(:user) }
      given!(:question){ create :question }
      given!(:answer){ create :answer, question: question }

      background do
        sign_in user
        visit question_path(question)
      end

      scenario 'can see links to vote' do
        within('.answers') do                     
          expect(page).to have_link "Up", href: upvote_answer_path(answer)
          expect(page).to have_link "Down", href: downvote_answer_path(answer)
        end
      end   

      scenario 'can see answer rating' do
        within('.answers') do          
          within('.answer_rating') do
            expect(page).to have_content 0
          end
        end
      end

      context 'can create a vote' do
        scenario 'can upvote an answer', js: true do          
          within('.answers') do
            click_on "Up"
            wait_for_ajax          
            within('.raiting') do
              expect(page).to have_content 1
            end
            expect(page).to have_link 'Delete'            
          end
        end

        scenario 'can downvote an answer', js: true do
          within('.answers') do          
            click_on "Down"
            wait_for_ajax          
            within('.raiting') do
              expect(page).to have_content -1
            end
            expect(page).to have_link 'Delete'            
          end
        end          
      end
      context 'can delete a vote' do
        scenario 'when upvoted', js: true do          
          within('.answers') do
            click_on "Up"
            wait_for_ajax          
            within('.raiting') do
              expect(page).to have_content 1
            end            
            click_on 'Delete'
            wait_for_ajax
            within('.raiting') do
              expect(page).to have_content 0
            end 
            expect(page).to have_link 'Up', href:"/answers/#{answer.id}/upvote"
            expect(page).to have_link 'Down', href:"/answers/#{answer.id}/downvote"           
          end        
        end

        scenario 'when downvoted', js: true do
          within('.answers') do          
            click_on "Down"
            wait_for_ajax          
            within('.raiting') do
              expect(page).to have_content -1
            end            
            click_on 'Delete'
            wait_for_ajax
            within('.raiting') do
              expect(page).to have_content 0
            end
            expect(page).to have_link 'Up', href:"/answers/#{answer.id}/upvote"
            expect(page).to have_link 'Down', href:"/answers/#{answer.id}/downvote"            
          end       
        end
      end
    end
  end
end