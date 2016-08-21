class Comment < ActiveRecord::Base
  include HasUser
  belongs_to :commentable, polymorphic: true
  validates :commentable, :body, presence: true
end
