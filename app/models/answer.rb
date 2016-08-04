class Answer < ActiveRecord::Base

  include HasUser
  
  belongs_to :question  
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true  

  scope :order_by_best, -> { order(best: :desc) }

  def the_best!
    transaction do
      self.question.answers.where(best: true).update_all(best: false)    
      update! best: true
    end      
  end    
end
