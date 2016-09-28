class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers:[:facebook, :twitter]
  has_many :questions, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  has_many :answers, dependent: :destroy #foreign_key on_delete: :cascade is set in db
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many :votes, dependent: :destroy  

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def author_of?(comp)
    id == comp.user_id
  end 

  def self.create_self_and_authorization!(auth, email)
    pass = Devise.friendly_token[0, 20]
    transaction do             
      @user = User.create!(name: auth['info']['name'], email: email, password: pass, password_confirmation: pass)     
      @user.authorizations.create!(provider: auth['provider'], uid: auth['uid'])
    end
  end

  def create_authorization!(auth)
    transaction do
      authorizations.create!(provider: auth['provider'], uid: auth['uid'])
      update!(confirmed_at: nil)
    end    
    self.send_confirmation_instructions 
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.try(:email)
    if email      
      name = auth.info[:name]    
      user = User.find_by(email: email)
      if user        
        user.authorizations.create(provider: auth.provider, uid: auth.uid) if user        
      else
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email, name: name, password: password, password_confirmation: password)
        user.skip_confirmation!
        transaction do
          user.save!
          user.authorizations.create!(provider: auth.provider, uid: auth.uid)
        end
      end 
    end   
    user    
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
