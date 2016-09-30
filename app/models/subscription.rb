class Subscription < ActiveRecord::Base  
  belongs_to :subscriber, class_name: User, foreign_key: :user_id
  belongs_to :question, touch: true
  validates :user_id, :question_id, presence: true
end
