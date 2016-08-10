class Vote < ActiveRecord::Base

  include HasUser  
  belongs_to :votable, polymorphic: true   

  validates :votable, :vote_field, presence: true 
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] } 

  def vote_permitted?
    self.user == self.votable.user   
  end  

  def down?
    self.vote_field == -1 
  end

  def up?
    self.vote_field == 1 
  end
end
