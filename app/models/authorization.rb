class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :user, presence: true
end
