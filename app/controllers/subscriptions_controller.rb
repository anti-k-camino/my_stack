class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :set_subscription,  only: :create
  before_action :load_subscription, only: :destroy

  authorize_resource

  respond_to :js

  def create
    @subscription.save
    respond_with @subscription
  end

  def destroy
    respond_with @subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = @question.subscriptions.new(user_id: current_user.id)
  end

  def load_subscription
    @subscription = Subscription.find_by(question_id: @question.id,
                                         user_id: current_user.id)
  end
end
