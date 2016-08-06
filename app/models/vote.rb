class Vote < ActiveRecord::Base

  include HasUser  
  belongs_to :votable, polymorphic: true 
  before_save :check_vote_permission 

  validates :votable, :vote_field, presence: true 
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] } 

  def check_vote_permission?
    self.user == self.votable.user   
  end  
end
