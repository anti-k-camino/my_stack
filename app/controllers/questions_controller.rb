class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_question, only:[:show, :update, :destroy, :upvote, :downvote]
  before_action :check_permission, only:[:update, :destroy]  

  include Voted

  def index
    @questions = Question.all    
  end

  def show   
    @answer = @question.answers.new
    @answer.attachments.build
    if @question.user_voted?(current_user)
      @vote = @question.get_vote current_user
    else
      @vote = Vote.new
    end
  end

  def new
    @question = Question.new
    @question.attachments.build
  end  
  
  def update    
    @question.update(question_params)  
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save            
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy    
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully destroyed.'    
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
end
