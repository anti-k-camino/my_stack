class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  has_many :answers, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
