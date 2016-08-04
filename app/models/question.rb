class Question < ActiveRecord::Base 
  
  include HasUser

  has_many :answers, dependent: :destroy 
  has_many :attachments, as: :attachable, dependent: :destroy  
  has_many :votes, as: :votable, dependent: :destroy
  has_many :users, through: :votes
  
  validates :title, :body, presence: true  

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def check_if_voted? user
    self.users.include? user
  end

  def get_vote user
    self.votes.where(user: user).first
  end

  def rating
    self.votes.sum(:vote_field)  
  end
end
