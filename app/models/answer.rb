class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true 

  scope :order_by_best, -> { order(best: :desc) }

  def the_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)
    end
    update! best: true       
  end 
  
  def best?
   self.best
  end  
end
