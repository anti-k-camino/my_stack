class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user) 
    @user = user  
    if user
      user.admin? ? admin_abilities : user_abilities     
    else
      guest_abilities
    end    
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities    
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Comment], user: user
    can :upvote, [Question, Answer] do |resource|
      resource.user != user
    end
    can :downvote, [Question, Answer] do |resource|
      resource.user != user
    end
    can :destroy, [Vote], user: user 
    can :manage, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
    can :best, Answer do |answer|
      answer.question.user_id == user.id
    end 
  end
end
