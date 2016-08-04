class Question < ActiveRecord::Base 
  
  include HasUser
  include Rating
  include Attachments

  has_many :answers, dependent: :destroy  
  validates :title, :body, presence: true 
  
end
