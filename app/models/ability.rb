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
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment, Vote], user_id: user.id
    can [:upvote, :downvote], [Question, Answer] do |resource|
      resource.user_id != user.id
    end    
    can :manage, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
    can :best, Answer do |answer|
      answer.question.user_id == user.id
    end 
    can :me, User, id: user.id
    can :create, Subscription do |subscription|
      !user.subscriptions.include?(subscription)
    end

    can :destroy, Subscription do |subscription|
      user.subscriptions.include?(subscription)
    end          
  end
end
