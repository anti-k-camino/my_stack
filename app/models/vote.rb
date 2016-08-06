class Vote < ActiveRecord::Base

  include HasUser
  include ActiveModel::Validations 
  
  belongs_to :votable, polymorphic: true
  
  validates_with PermissionValidator
  validates :votable, :vote_field, presence: true 
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }  

end
