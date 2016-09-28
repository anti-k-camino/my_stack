class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    if answer.present?
      answer.question.subscribers.find_each do |user|
        NewAnswerMailer.notification(user, answer).deliver_later
      end
    end
  end
end
