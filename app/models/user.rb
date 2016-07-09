class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  has_many :answers, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def permission? comp
    id == comp.user_id
  end
end
