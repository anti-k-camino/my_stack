require_relative '../acceptance_helper'

feature 'Search' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment , body: 'somebody', user: user, commentable: answer) }
  

  background do
    ThinkingSphinx::Test.index
    sleep(0.25)
    visit search_index_path
  end

  scenario 'Visit search page', :sphinx do
    expect(current_path).to eq search_index_path
  end

  scenario 'See search query', :sphinx do
    expect(page).to have_field 'Search'
  end

  scenario 'See result with all', :sphinx do
    select 'All', from: 'model'
    fill_in 'query', with: question.title
    click_button 'Find'

    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).to have_content user.email
  end

  scenario 'See result with questions', :sphinx do
    select 'Question', from: 'model'
    fill_in 'query', with: question.title
    click_button 'Find'
    expect(page).to have_content question.title
  end

  scenario 'See result with answers', :sphinx do
    select 'Answer', from: 'model'
    fill_in 'query', with: answer.body
    click_button 'Find'
    expect(page).to have_content answer.body
  end

  scenario 'See result with comments', :sphinx do
    select 'Comment', from: 'model'
    fill_in 'query', with: comment.body
    click_button 'Find'
    expect(page).to have_content comment.body
  end

  scenario 'See result with users', :sphinx do
    select 'User', from: 'model'
    fill_in 'query', with: user.email
    click_button 'Find'
    expect(page).to have_content user.email
  end
end