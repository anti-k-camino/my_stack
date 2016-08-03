require_relative '../acceptance_helper'

feature 'Question voting',%q{
  As an authenticated user
  and not the author of a question
  in oredr to mark the best questions
  I want to vote for a question
} do 
  context 'Non authenticated user' do
    given!(:question){ create :question }

    scenario 'can not vote for the question'do
      visit question_path(question)
      within('.question') do
        expect(page).to_not have_content 'Vote +'
        expect(page).to_not have_content 'Vote -'
      end
    end
  end

  describe 'Authenticated user' do
    given!(:user){ create :user }
    background do
      sign_in user      
    end   

    context 'author of a question' do
      given!(:question){ create :question, user: user }
            
      scenario 'can not vote for the question'do
        visit question_path(question)        
        within('.question') do
          expect(page).to_not have_content 'Vote +'
          expect(page).to_not have_content 'Vote -'
        end
      end
    end

    context 'not the author of a question' do
      given!(:question){ create :question }
      background do
        visit question_path(question)
      end

      scenario 'has an opporunity to vote' do
        within('.question') do
          expect(page).to have_content 'Vote +'
          expect(page).to have_content 'Vote -'
        end
      end     

    end

  end 
end
  
