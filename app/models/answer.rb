class Answer < ActiveRecord::Base

  include HasUser
  include Attachments
  include Rating
  
  belongs_to :question
  validates :body, :question_id, presence: true
  scope :order_by_best, -> { order(best: :desc) }

  def the_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)    
      update! best: true
    end      
  end    
end
