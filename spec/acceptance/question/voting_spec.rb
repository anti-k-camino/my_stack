require_relative '../acceptance_helper'
feature 'Vote for question', %q{
  In order to match the best question
  as an authenticated user
  and not the author of a question
  I want to vote for a question
}do
  context 'Non authenticated user' do
    given!(:question){ create :question }

    scenario 'can not vote for a question' do
      visit question_path(question)
      within('.question') do        
        expect(page).to_not have_link "Up", href: upvote_question_path(question)
        expect(page).to_not have_link "Down", href: downvote_question_path(question)
      end      
    end

  end

  context 'Authenticated user' do
    context 'author of a question' do
      given(:user){ create(:user) }
      given!(:question){ create :question, user: user }

      scenario 'can not see links to vote' do
        sign_in user
        visit question_path(question)      
        expect(page).to_not have_link "Up", href: upvote_question_path(question)
        expect(page).to_not have_link "Down", href: downvote_question_path(question)
      end
    end

    context 'not author of a question' do
      given(:user){ create(:user) }
      given!(:question){ create :question }

      background do
        sign_in user
        visit question_path(question)
      end

      scenario 'can see links to vote' do             
        expect(page).to have_link "Up", href: upvote_question_path(question)
        expect(page).to have_link "Down", href: downvote_question_path(question)
      end   

      scenario 'can see question rating' do
        within('.rating') do
          expect(page).to have_content 0
        end
      end

      context 'can create a vote' do
        scenario 'can upvote a question', js: true do          
          click_on "Up"
          wait_for_ajax          
          within('.raiting') do
            expect(page).to have_content 1
          end
          within('.voting_dom') do
            expect(page).to have_link 'Delete'
          end
        end

        scenario 'can downvote a question', js: true do          
          click_on "Down"
          wait_for_ajax          
          within('.raiting') do
            expect(page).to have_content -1
          end
          within('.voting_dom') do
            expect(page).to have_link 'Delete'
          end
        end          
      end

      context 'can delete a vote' do
        scenario 'when upvoted', js: true do          
          click_on "Up"
          wait_for_ajax          
          within('.raiting') do
            expect(page).to have_content 1
          end
          within('.voting_dom') do
            click_on 'Delete'
          end          
          wait_for_ajax
          within('.raiting') do
            expect(page).to have_content 0
          end
          within('.voting_dom') do
            expect(page).to have_link 'Up', href:"#{question.id}/upvote"
            expect(page).to have_link 'Down', href:"#{question.id}/downvote"
          end
        end

        scenario 'can downvote a question', js: true do          
          click_on "Down"
          wait_for_ajax          
          within('.raiting') do
            expect(page).to have_content -1
          end
          within('.voting_dom') do
            click_on 'Delete'
          end          
          wait_for_ajax
          within('.raiting') do
            expect(page).to have_content 0
          end
          within('.voting_dom') do
            expect(page).to have_link 'Up', href:"#{question.id}/upvote"
            expect(page).to have_link 'Down', href:"#{question.id}/downvote"
          end
        end
      end
    end
  end
  
end