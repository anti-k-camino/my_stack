class DailyDigestWorker 
  includes Sidekiq::Worker
  includes Sidekiq::Schedulable

  recurrence {daily(1)}
  def perform
    User.send_daily_digest
  end
end