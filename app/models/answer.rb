class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, :question, presence: true  
end
