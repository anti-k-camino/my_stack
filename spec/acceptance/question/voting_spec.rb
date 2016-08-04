require_relative '../acceptance_helper'
feature 'Vote for question', %q{
  In order to match the best question
  as an authenticated user
  and not the author of a question
  I want to vote for a question
}do
  context 'Non authenticated user' do
    given!(:question){ create :question }

    scenario 'Non authenticated user can not vote for a question' do
      visit question_path(question)
      within('.question') do
        expect(page).to_not have_css("img[src*='/assets/up-81cf844a88967b28f9245b872e7d05da828bafb92c6dae1df0ed48a41f0e6736.png']")
        expect(page).to_not have_css("img[src*='/assets/down-1d68ce8366be14be3b4352d42e0aaf6e8f5ebb97690b3a8646bf774e31486249.png']")
      end      
    end

  end

  context 'Authenticated user' do
    given(:user){ create(:user) }
    given!(:question){ create :question }
    scenario 'Can see links to vote' do
      sign_in user
      visit question_path(question)      
      expect(page).to have_css("img[src*='/assets/up-81cf844a88967b28f9245b872e7d05da828bafb92c6dae1df0ed48a41f0e6736.png']")
      expect(page).to have_css("img[src*='/assets/down-1d68ce8366be14be3b4352d42e0aaf6e8f5ebb97690b3a8646bf774e31486249.png']")
    end

  end
  
end