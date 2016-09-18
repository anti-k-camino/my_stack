class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers
  has_many :comments
  has_many :attachments

  def comments
    object.comments.order(updated_at: :asc)
  end

  def answers
    object.answers.order(updated_at: :asc)
  end

  def attachments
    object.attachments.order(updated_at: :asc)
  end

  def short_title
    object.title.truncate(10)
  end
end
