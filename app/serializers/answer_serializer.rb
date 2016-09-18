class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
    
  has_many :comments
  has_many :attachments 

  def comments
    object.comments.order(updated_at: :asc)
  end

  def attachments
    object.attachments.order(updated_at: :asc)
  end
end
