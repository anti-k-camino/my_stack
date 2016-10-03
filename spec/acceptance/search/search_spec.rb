require_relative '../acceptance_helper'

feature 'User searches documents', '
  In order to find neccessary information
  As an guest
  I want to be able to search documents
' do
  given!(:user)     { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer)   { create :answer,   user: user }
  given!(:comment)  { create :comment,  commentable: question, user: user }

  scenario 'Guest try to find User', sphinx: true do
    search(query: user.email, model: 'Users')

    expect(page).to     have_content "User #{user.email} registered at"
    expect(page).not_to have_content "asked"
    expect(page).not_to have_content "answered"
    expect(page).not_to have_content "commented"
  end

  scenario 'Guest try to find Question', sphinx: true do
    search(query: user.email, model: 'Questions')

    expect(page).to     have_content "User #{user.email} asked"
    expect(page).not_to have_content "registered at"
    expect(page).not_to have_content "answered"
    expect(page).not_to have_content "commented"
  end

  scenario 'Guest try to find Answer', sphinx: true do
    search(query: user.email, model: 'Answers')

    expect(page).to     have_content "User #{user.email} answered"
    expect(page).not_to have_content "asked"
    expect(page).not_to have_content "registered at"
    expect(page).not_to have_content "commented"
  end

  scenario 'Guest try to find Comments', sphinx: true do
    search(query: user.email, model: 'Comments')

    expect(page).to     have_content "User #{user.email} commented"
    expect(page).not_to have_content "asked"
    expect(page).not_to have_content "answered"
    expect(page).not_to have_content "registered at"
  end

  scenario 'Guest try to find Anywhere', sphinx: true do
    search(query: user.email, model: 'Anywhere')

    expect(page).to  have_content "User #{user.email} registered at"
    expect(page).to  have_content "User #{user.email} asked"
    expect(page).to  have_content "User #{user.email} answered"
    expect(page).to  have_content "User #{user.email} commented"
  end
end