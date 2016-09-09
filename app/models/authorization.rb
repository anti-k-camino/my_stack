class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :user, presence: true  
  validates :uid, uniqueness: { scoped_to: :provider } 

end
