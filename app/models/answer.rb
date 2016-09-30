class Answer < ActiveRecord::Base

  include HasUser
  include Attachments
  include Rating
  include Commentings
  
  belongs_to :question
  validates :body, :question_id, presence: true
  scope :order_by_best, -> { order(best: :desc) }
  after_save :sent_notification, on: :create

  def the_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)    
      update! best: true
    end      
  end 

  private
  def sent_notification
    NewAnswerNotificationJob.perform_now(self)
  end   
end
