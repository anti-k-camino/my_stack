module Votings
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
    has_many :users, through: :votes    
  end 

  def user_voted?(user)   
    self.votes.where(user: user).exists?
  end

  def get_vote(user)
    self.votes.where(user: user).first
  end

  def upvote(user)    
    @vote = self.votes.new(user: user, vote_field: 1)
  end

  def downvote(user)
    @vote = self.votes.new(user: user, vote_field: -1)    
  end
end