require_relative '../acceptance_helper'

feature 'The author of question is notified when a new answer appears', '
  In order to watch out for new answers
  As an author of question
  I want to be able to receive notifications by email
' do
  given!(:user){ create :user }
  given!(:question){ create :question, user: user }  
  given!(:answer){ create :answer, question: question }

  scenario 'The author of quesiton subscribed and can unsubscribe', js: true do
    sign_in user
    visit question_path(question)

    expect(page).not_to have_content 'Subscribe'    
    expect(page).to have_content 'Unsubscribe'
    expect(question.subscribers).to include user

    click_on 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
    expect(page).not_to have_content 'Unsubscribe'
    expect(question.subscribers).not_to include user
  end

  scenario 'The author of question receive notification' do
    clear_emails
    NewAnswerMailer.notification(question.subscribers.first, answer).deliver_now
    open_email question.user.email

    #expect(current_email.header('To')).to eq question.user.email
    expect(current_email).to have_content question.title
    expect(current_email).to have_content answer.user.email
    expect(current_email).to have_content answer.body

    current_email.click_link 'Open question'
    expect(page).to have_current_path question_path(question)
  end

end