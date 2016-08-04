class Question < ActiveRecord::Base 
  
  include HasUser
  include Votings
  include Attachments

  has_many :answers, dependent: :destroy  
  validates :title, :body, presence: true  

  def rating
    self.votes.sum(:vote_field)  
  end
end
