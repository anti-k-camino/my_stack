class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy 
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy
  has_many :users, through: :votes
  
  validates :title, :body, :user_id,  presence: true  

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def rating
    self.votes.inject(0){|sum,x| sum + x.vote_field }   
  end
end
