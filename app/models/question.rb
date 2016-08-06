class Question < ActiveRecord::Base 
  
  include HasUser
  include Attachments
  include Rating
  
  
  has_many :answers, dependent: :destroy 
   
  validates :title, :body, presence: true 
  
end
