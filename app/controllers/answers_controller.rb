class AnswersController < ApplicationController
  before_action :set_question, except:[:show, :edit, :update, :destroy]
  before_action :set_answer, only:[:show, :edit, :update, :destroy]
  before_action :not_author?, only:[:edit, :update, :destroy]
  
  def index
    @answers = @question.answers
  end
  
  def show
  end

  def edit    
  end

  def create    
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice:'Your answer successfully added.'
    else      
      render "questions/show"
    end
  end

  def update     
    if @answer.update(answer_params)
      redirect_to question_path @answer.question, notice:'Your answer successfully updated'
    else
      render :edit
    end
  end

  def destroy  
    @question = @answer.question      
    @answer.destroy
    redirect_to @question, notice: 'Answer successfully destroyed.'    
  end

  private
  def not_author?
    if !current_user.permission? @answer    
      redirect_to question_path @answer.question, notice: 'Restricted' and return
    end
  end

  def set_question
    @question = Question.find params[:question_id]
  end 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
