class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.dailymailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    mail to: user.email
  end
end
