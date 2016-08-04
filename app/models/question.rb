class Question < ActiveRecord::Base 
  
  include HasUser
  include Votings

  has_many :answers, dependent: :destroy 
  has_many :attachments, as: :attachable, dependent: :destroy  
  
  validates :title, :body, presence: true  

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def rating
    self.votes.sum(:vote_field)  
  end
end
