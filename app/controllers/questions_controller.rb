class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_question, only:[:show, :update, :destroy, :upvote, :downvote]
  before_action :check_permission, only:[:update, :destroy] 
  before_action :set_gon_user, only:[:show] 
  after_action :publish_to, only:[:create, :destroy]
  before_action :build_answer, only:[:show]

  respond_to :js

  include Voted

  def index
    respond_with(@questions = Question.all)    
  end

  def show   
    @answer.attachments.build    
    if @question.user_voted?(current_user)
      @vote = @question.get_vote(current_user)
    else
      @vote = Vote.new
    end
  end

  def new
    respond_with @question = Question.new        
  end  
  
  def update    
    @question.update(question_params)  
  end

  def create    
    
    respond_with @question = current_user.questions.create(question_params)
   
  end

  def destroy    
    respond_with @question.destroy        
  end
  
  private
  def check_permission
    if !current_user.author_of? @question    
      render :show, id: @question, notice: 'Restricted' and return
    end
  end
 
  def set_question
    @question = Question.find params[:id]
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :type, :_destroy])
  end

  def publish_to
    PrivatePub.publish_to '/questions', resp: { question: @question.to_json, method: action_name } if @question.errors.empty?
  end

  def set_gon_user
    if user_signed_in?
      gon.user = current_user
    end
  end

  def build_answer
    @answer = @question.answers.new
  end
end
