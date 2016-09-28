class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.yesterday.to_a
    if questions.present?
      User.find_each do |user|
        DailyMailer.digest(user, questions).deliver_later
      end
    end
  end
end