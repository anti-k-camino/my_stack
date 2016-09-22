# Preview all emails at http://localhost:3000/rails/mailers/dailymailer
class DailymailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/dailymailer/digest
  def digest
    Dailymailer.digest
  end

end
