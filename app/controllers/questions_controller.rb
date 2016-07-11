class QuestionsController < ApplicationController
  before_action :set_question, only:[:show, :edit, :update, :destroy]
  before_action :check_permission, only:[:edit, :update, :destroy]
  def index
    @questions = Question.all    
  end
  def show   
    @answer = @question.answers.new
  end
  def new
    @question = Question.new
  end
  def edit 
  end
  def update    
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
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
    if !current_user.permission? @question    
      render :show, id: @question, notice: 'Restricted' and return
    end
  end

  def set_question
    @question = Question.find params[:id]
  end
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
