require_relative '../acceptance_helper'

feature 'asnwer votes', %q{
  As an authenticated user
  And not the author of an asnwer
  In order to mark best answers
  I want to vote for the answer
} do 
  context 'Can not vote' do
    given(:user){ create :user }     
    given(:question){ create :question }    
    given!(:answer){ create :answer, question: question, user: user }

    scenario 'as non authenticated user' do
      visit question_path(question)
      expect(page).to have_content answer.body
      within("#answer_dom_#{ answer.id }") do
        expect(page).to_not have_content "vote +"
        expect(page).to_not have_content "vote -"
      end
    end

    scenario 'as the author of an answer' do
      sign_in user
      visit question_path(question)
      expect(page).to have_content answer.body
      within("#answer_dom_#{ answer.id }") do
        expect(page).to_not have_content "vote +"
        expect(page).to_not have_content "vote -"
      end
    end
  end  

  context 'Can vote' do
    given(:user){ create :user }     
    given(:question){ create :question }    
    given!(:answer){ create :answer, question: question }

    background do
      sign_in user
      visit question_path(question)      
    end

    scenario 'authenticated user not the author of an answer' do
      expect(page).to have_content answer.body
    end
    
  end
end

