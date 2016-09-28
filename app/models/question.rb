class Question < ActiveRecord::Base
  
  include HasUser
  include Attachments
  include Rating
  include Commentings  
  
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions

  after_create :subscribe_author
   
  validates :title, :body, presence: true
  scope :yesterday, -> { where(created_at: Time.current.yesterday.all_day) }

  private
  def subscribe_author
    subscriptions.create(user_id: user_id)
  end  
end
