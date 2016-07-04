class Answer < ActiveRecord::Base
  belongs_to :question, foreign_key: :question_id
  belongs_to :user, foreign_key: :user_id

  validates :body, :question, presence: true  
end
