class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true 

  scope :order_by_best, -> { order(best: :desc).reorder(updated_at: :desc) }

  def the_best!
    self.question.answers.where(best: true).first.update!(best: false)
    update! best: true       
  end   
end
