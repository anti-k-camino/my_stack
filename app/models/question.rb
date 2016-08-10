class Question < ActiveRecord::Base
  
  include HasUser
  include Attachments
  include Rating
  include Commentings  
  
  has_many :answers, dependent: :destroy
   
  validates :title, :body, presence: true  
end
