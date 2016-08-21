module Commentings
  extend ActiveSupport::Concern
  included do    
    has_many :comments, as: :commentable, dependent: :destroy       
  end 
end