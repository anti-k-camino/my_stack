require_relative '../acceptance_helper'

feature 'Remove comment from answer', %q{
  In order to clearify information
  As a registered user
  I want to remove a comment
} do 
  
  given(:user){ create :user }
  given(:another_user){ create :user }
  given!(:question){ create :question, user: user }
  given!(:answer){ create :answer, question: question, user: user }  
  given!(:comment){ create :comment, commentable: answer, user: user, body: 'Comment olala text'}
  given!(:another_comment){ create :comment, commentable: answer, user: another_user, body: 'Another comment olala text'}
  

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)    
    end

    context 'author of a comment' do    
      scenario 'can delete a comment', js: true do
        expect(page).to have_content "Comment olala text"
        within("#answer_comment_#{ comment.id }") do
          click_on 'Delete'
        end
        expect(page).to_not have_content "Comment olala text"
      end
    end
    
    context 'non author of a comment' do
      scenario 'can not delete a comment', js: true do
        expect(page).to have_content "Another comment olala text"
        within("#answer_comment_#{ another_comment.id }") do
          expect(page).to_not have_link 'Delete'
        end        
      end
    end
  end

  context "Non authenticated user" do
    
    scenario 'can not delete a comment' do
      visit question_path(question)
      within("#answer_#{answer.id}") do        
        expect(page).to_not have_link "Delete"
      end
    end
  end
end