class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy 
  has_many :attachments, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, :user_id,  presence: true

  accepts_nested_attributes_for :attachments 
end
