class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy 
  belongs_to :user
  validates :title, :body, :user_id,  presence: true  
  def has_best?    
    return true if(answers.where(best: :true).count > 0)
    return false    
  end
end
