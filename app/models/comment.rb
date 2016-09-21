class Comment < ActiveRecord::Base
  include HasUser
  belongs_to :commentable, polymorphic: true

  validates :user, :body, :commentable, presence: true
end
