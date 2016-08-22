require_relative '../acceptance_helper'

feature 'Remove comment from question', %q{
  In order to clearify information
  As a registered user
  I want to remove a comment
} do 
  
  given(:user){ create :user }
  given(:another_user){ create :user }
  given!(:question){ create :question, user: user }  
  given!(:comment){ create :comment, commentable: question, user: user, body: 'Comment olala text'}
  given!(:another_comment){ create :comment, commentable: question, user: another_user, body: 'Another comment olala text'}
  

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)    
    end

    context 'author of a comment' do    
      scenario 'can delete a comment', js: true do
        expect(page).to have_content "Comment olala text"
        within("#question_comment_#{ comment.id }") do
          click_on 'Delete'
        end
        expect(page).to_not have_content "Comment olala text"
      end
    end
    
    context 'non author of a comment' do
      scenario 'can not delete a comment', js: true do
        expect(page).to have_content "Another comment olala text"
        within("#question_comment_#{ another_comment.id }") do
          expect(page).to_not have_link 'Delete'
        end        
      end
    end
  end

  context 'Non authenticated user' do 
    scenario 'can not delete a comment' do
      visit question_path(question)
      within('.question_comments') do
        expect(page).to_not have_selector "textarea"
        expect(page).to_not have_link "Delete"
      end    
    end
  end
end