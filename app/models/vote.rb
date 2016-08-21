class Vote < ActiveRecord::Base

  include HasUser  
  belongs_to :votable, polymorphic: true   

  validates :votable, :vote_field, presence: true 
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] } 
  validate :vote_permission 

  def vote_permission
    errors.add(:permission, 'denied') if self.vote_permitted?
  end

  def vote_permitted?    
    if votable.present?
      self.user == self.votable.user 
    else
      false
    end     
  end  

  def down?
    self.vote_field == -1 
  end

  def up?
    self.vote_field == 1 
  end
end
